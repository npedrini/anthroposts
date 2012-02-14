package net.looklisten.notes.layout
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.core.UIComponent;
	
	import net.looklisten.notes.NoteConnectionDisplay;
	import net.looklisten.notes.NoteDisplay;
	import net.looklisten.notes.events.NoteLayoutEvent;
	import net.looklisten.notes.model.NotesModel;
	import net.looklisten.notes.soap.Note;
	
	public class _SimilarityLayout2 extends EventDispatcher implements NotesLayout
	{
		public static const LAYOUT_NAME:String = "common words";
		
		private var _notesModel:NotesModel=NotesModel.getInstance();
		
		private var origin:NoteDisplay;
		private var originWeight:int = 10;
		
		// a "SPEED" multiple applied to all of the forces in each iteration
		// (a higher number makes the graph move faster but also makes it more volatile)
		private const SPEED:int = 6;
		
		// actually an _inverse_ GRAVITY constant, used in calculating repulsive force
		private const GRAVITY:int = 30;
		
		// the maximum repulsive force that can be aqpplied in an iteration
 		private var max_repulsive_force_distance:int = 212;
 		//512;
 		
		// the current selected node (when a node is selected, no forces may be applied to it
    	private var selectedNode:int = -1;

		// parallel arrays
    	private var nodes:ArrayCollection = new ArrayCollection();
 		private var edges:Array = new Array();
 		private var originEdges:Array = new Array();
 		
 		private var connectionDisplay:NoteConnectionDisplay;
 		private var frame:UIComponent;
 		
		public function ForceDirectedLayout(_connectionDisplay:NoteConnectionDisplay)
		{
			connectionDisplay = _connectionDisplay;
			super();
		}
		
		public function doLayout( dataProvider:ArrayCollection,target:UIComponent,width:Number,height:Number,size:Number = 0, margin:Number = 0, hasChanged:Boolean = true ):void{
			
			if(dataProvider==null) return;
			
			frame = target;
			var nd:NoteDisplay;
			
			var a:int;
			var r:int;
			var a2:int;
			var r2:int;
			
			//	build an array of nodes for sorting
			nodes = new ArrayCollection();
			for(var i:int=0;i<dataProvider.length;i++)
			{
				nd = target.getChildByName("nd"+dataProvider[i].id) as NoteDisplay;
				// initialize the new node at a random offset from the origin
    			var offsetx:Number = (Math.random()*100)-50;
    			var offsety:Number = (Math.random()*100)-50;
    			nd.default_x = target.parent.width/2 + offsetx;
				nd.default_y = target.parent.height/2 + offsety;
				nd.default_rotation = 0;
				//	init neighbors
				nd.neighbors = 0;
				nd.mass = 1 + (nd.siblings!=null?nd.siblings.length:0);
				//1+Math.round(Math.random()*4);
				nd.layedOut=false;
				nodes.addItem(nd);
			}
			
			//	sort by num siblings
			var sort:Sort = new Sort();
			sort.fields = [new SortField("siblings")];
			sort.compareFunction = sortBySiblings;
			nodes.sort = sort;
			nodes.refresh();
			
			var node1:Note;
			var node2:Note;
			edges = new Array();
			for(var word:String in _notesModel.connections)
			{
				node1 = _notesModel.connections[word][0] as Note;
				for(var j:int = 1;j<_notesModel.connections[word].length;j++)
				{
					node2 = _notesModel.connections[word][j] as Note;
					if ( !edges[node1.id] )
      					edges[node1.id]=new Array();
					
					//(edges[node2.id] && edges[node2.id][node1.id]) || 
					if ((edges[node1.id] && edges[node1.id][node2.id])) continue;
					//	temp - uniform weight
      				edges[node1.id][node2.id] = word.length*10;
				}
			}
			
			var n:int = 0;
			for(var edge_id:String in edges)
			{
				nd = getNoteById(int(edge_id));
				//	count num neighbors
				n = 0;
				for each(var neighbor:String in edges[edge_id]) n++;
				
				nd.neighbors += n;
				for(var edge2_id:String in edges)
					getNoteById(int(edge2_id)).neighbors += n;
			}
			
			origin = nodes.getItemAt(0) as NoteDisplay;
			
			
			var timer:Timer = new Timer(100,20);
			timer.addEventListener(TimerEvent.TIMER,applyForce);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,layoutComplete);
			timer.start();
		}
		
		private function layoutComplete(event:TimerEvent):void{
			dispatchEvent(new NoteLayoutEvent(NoteLayoutEvent.LAYOUT_COMPLETE));
		}
		
		private function applyForce(event:TimerEvent):void{
			
			var distance:Object;
			for( var i:int = 0; i<nodes.length; i++ )
			{
		   		var nodeI:NoteDisplay = nodes[i] as NoteDisplay;
		    	
				for( var j:int = 0; j<nodes.length; j++ ) {
					if ( i != j )
					{
						var nodeJ:NoteDisplay = nodes[j] as NoteDisplay;
						
						// get the distance between nodes
						distance = calculateDistance( nodeI, nodeJ );
						
						// attractive force applied across an edge
						if ( edges[nodeI.note.id] && edges[nodeI.note.id][nodeJ.note.id] ) {
							attractiveForce(nodeI, nodeJ, distance);
						}
						
						// repulsive force between any two nodes
						repulsiveForce(nodeI, nodeJ, distance);
					}
				}
				
				// attractive force to the origin
				// get the distance between node and origin
				distance = calculateDistance( origin, nodeI );
				originForce(nodeI, distance);
				
				// SPEED multiple
				nodeI.force.x *= SPEED;
				nodeI.force.y *= SPEED;
				
				// add forces to node position
				nodeI.default_x += nodeI.force.x;
				nodeI.default_y += nodeI.force.y;
				
				// wipe forces for iteration
				nodeI.force.x=0;
				nodeI.force.y=0;
				
				// keep the node in our frame
				bounds(nodeI);
			}
		}
		
		private function calculateDistance(nodeI:NoteDisplay, nodeJ:NoteDisplay):Object{
			var distance:Object = {};
			// X Distance
			distance.dx = nodeI.default_x - nodeJ.default_x;
			// Y Distance
			distance.dy = nodeI.default_y - nodeJ.default_y;
			distance.d2 = (distance.dx*distance.dx+distance.dy*distance.dy);
			// Distance
			distance.d = Math.sqrt(distance.d2);
			
			return distance;
		}
		
		// apply an attractive force between a node and the origin
		// F = (currentLength - desiredLength)
		private function originForce( nodeI:NoteDisplay, distance:Object ):void {
			
			if ( originEdges[nodeI.note.id] ) {
				if ( int(nodeI.note.id) != selectedNode ) {
					var weight:Number = originEdges[nodeI.note.id];
					var attractive_force:Number = (distance.d - weight)/weight;
					nodeI.force.x += attractive_force * (distance.dx / distance.d);
					nodeI.force.y += attractive_force * (distance.dy / distance.d);
				}
			} else if ( int(nodeI.note.id) != selectedNode ) {
				var repulsive_force:Number = GRAVITY * nodeI.mass * origin.mass/distance.d2;
				var df:Number = max_repulsive_force_distance-distance.d;
				if ( df > 0 ) {
					repulsive_force *= (Math.log(df));
				}
				
				if ( repulsive_force < 1024 ) {
					nodeI.force.x -= repulsive_force * distance.dx / distance.d;
					nodeI.force.y -= repulsive_force * distance.dy / distance.d;
				}
			}
		}
		
		private function attractiveForce( nodeI:NoteDisplay, nodeJ:NoteDisplay, distance:Object ):void {
			
			//   F = (currentLength - desiredLength)
			var weight:Number = edges[nodeI.note.id][nodeJ.note.id];
			weight += (3 * (nodeI.neighbors+nodeJ.neighbors));
			
			if ( weight ) {
				var attractive_force:Number = (distance.d - weight)/weight;
				
				if ( int(nodeI.note.id) != selectedNode ) {
					nodeI.force.x -= attractive_force * distance.dx / distance.d;
					nodeI.force.y -= attractive_force * distance.dy / distance.d;
				}
				
				// since edges are one way in our data structure, we need to explicitly add
				// an equal attractive force to our neighbor
				if ( int(nodeJ.note.id) != selectedNode ) {
					nodeJ.force.x += attractive_force * distance.dx / distance.d;
					nodeJ.force.y += attractive_force * distance.dy / distance.d;
				}
			}
		}
		
		private function repulsiveForce( nodeI:NoteDisplay, nodeJ:NoteDisplay, distance:Object ):void {
			//   force = GRAVITY*(mass1*mass2)/distance^2.
			var repulsive_force:Number = GRAVITY * nodeI.mass * nodeJ.mass/distance.d2;
			var df:Number = max_repulsive_force_distance-distance.d;
			if ( df > 0 ) {
				repulsive_force *= (Math.log(df));
			}
			
			if ( repulsive_force < 1024 ) {
				nodeI.force.x += repulsive_force * distance.dx / distance.d;
				nodeI.force.y += repulsive_force * distance.dy / distance.d;
			}
 		}
 		
 		private function bounds( node:NoteDisplay ):void {
			
			var m:int = 10;
			var d:Number = (node.mass*4*2) + 4;
			var cxl:Number = node.default_x;
			var cxm:Number = node.default_x + d;
			var cyl:Number = node.default_y;
			var cym:Number = node.default_y + d;
			
			if ( cxl < 0 ) { node.default_x  = m; }
			if ( cyl < 0 ) { node.default_y  = m; }
			
			if ( cxm > frame.parent.width - m  ) { node.default_x  = frame.parent.width - d - m; }
			if ( cym > frame.parent.height - m ) { node.default_y  = frame.parent.height - d - m; }
		}
		
		private function sortBySiblings(a:Object, b:Object, fields:Array = null):int{
			//	null cases
			if(a.siblings==null && b.siblings==null) return 0;
			if(a.siblings==null && b.siblings!=null && b.siblings.length) return 1;
			if(a.siblings!=null && a.siblings.length && b.siblings==null) return -1;
			//	non null cases
			if(a.siblings.length == b.siblings.length) return 0;
			if(a.siblings.length>b.siblings.length) return -1;
			if(a.siblings.length<b.siblings.length) return 1;
			return 0;
		}
		
		private function getNoteById(id:int):NoteDisplay{
			for(var i:int=0;i<nodes.length;i++)
				if(nodes[i].note.id == id) return nodes[i] as NoteDisplay;
			return null;
		}
		public function get name():String{
			return GridLayout.LAYOUT_NAME;
		}

		public function get setsHeight():Boolean{
			return false;
		}
		
		public function get sortable():Boolean{
			return false;
		}
	}
}