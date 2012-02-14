package net.looklisten.utils
{
	public class StringUtils
	{
		public function StringUtils()
		{
		}
		
		public static function toSentenceCase(value:String):String{
			return 	value.charAt(0).toUpperCase() + 
					value.substr(1,value.length).toLocaleLowerCase();
		}
		
		public static function replace(value:String,...args):String
		{
			for(var i:int=0;i<args.length;i++)
			{
				value = value.replace("$"+(i+1),args[i]);
			}
			return value;
		}

	}
}