package firstRecharge
{
	import com.pickgliss.loader.DataAnalyzer;
	import com.pickgliss.utils.ObjectUtils;
	import firstRecharge.info.RechargeData;
	
	public class FirstRechargeAnalyer extends DataAnalyzer
	{
		
		public var goodsList:Vector.<RechargeData>;
		
		public function FirstRechargeAnalyer(onCompleteCall:Function)
		{
			super(onCompleteCall);
		}
		
		override public function analyze(data:*) : void
		{
			var xml:XML = new XML(data);
			var len:int = int(xml.item.length());
			var xmllist:XMLList = xml..item;
			for(var i:int = 0; i < len; i++)
			{
				data = new RechargeData();
				ObjectUtils.copyPorpertiesByXML(data,xmllist[i]);
				this.goodsList.push(data);
			}
		}
	}
}

