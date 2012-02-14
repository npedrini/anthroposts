package net.looklisten.components
{
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.controls.CheckBox;
	import mx.controls.Text;
	import mx.effects.Fade;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	public class InfoBubble extends TitleWindow
	{
		private var messages:ArrayCollection = new ArrayCollection();
		
		public var currentMessage:String = null;
		private var _so:SharedObject;
		
		//	children
		private var _messageText:Text;
		private var _showAgain:CheckBox;
		
		public function InfoBubble()
		{
			super();
			
			_so = SharedObject.getLocal("AnthroPosts");
			
			percentWidth=100;
			percentHeight=100;
			
			showCloseButton=true;
			addEventListener(CloseEvent.CLOSE,onClose);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(_messageText==null)
			{
				_messageText = new Text();
				_messageText.percentWidth=100;
				addChild(_messageText);
			}
			
			if(_showAgain==null)
			{
				_showAgain = new CheckBox();
				_showAgain.label="Don't show me this again"
				//addChild(_showAgain);
			}
		}
		
		public function addMessage(message:String):int
		{
			var messageId:int = messages.length;
			messages.addItem( {id:messageId,text:message} );
			return messages.length-1;
		}
		
		public function showMessage(messageText:String,titleText:String=null,showIfAlreadySeen:Boolean=true):void
		{
			//	don't play if told to ignore
			if(!showIfAlreadySeen && _so.data.shownMessages!=null && _so.data.shownMessages.indexOf(messageText)>-1) 
			{
				close();
				return;
			}
			
			currentMessage = messageText;
			
			_messageText.text = messageText.toUpperCase();
			title = titleText.toUpperCase();
		}
		
		private function onClose(event:CloseEvent):void
		{
			if(currentMessage!=null)
			{
				if(_so.data.shownMessages==null) 
					_so.data.shownMessages = new Array(currentMessage);
				else if(_so.data.shownMessages.indexOf(currentMessage)==-1)
					_so.data.shownMessages.push(currentMessage);
				_so.flush();
				
				/*
				if(_so.data.shownMessages==null)
				{ 
					return;
				}
				else if(_so.data.shownMessages.indexOf(currentMessage.id)>-1)
				{
					(_so.data.shownMessages as Array).splice(_so.data.shownMessages.indexOf(currentMessage.id),1);
					_so.flush();
				}	
				*/
			}
			close();
		}
		
		private function close():void
		{
			if(isPopUp) PopUpManager.removePopUp(this);
		}
	}
}