package overSeasCommunity.vietnam.openapi
{
	import com.pickgliss.loader.DataAnalyzer;
	
	public class ZMResponseAnalyzer extends DataAnalyzer
	{
		
		public var result:*;
		
		public var UserId:int;
		
		public function ZMResponseAnalyzer(onCompleteCall:Function)
		{
			super(onCompleteCall);
		}
		
		override public function analyze(data:*) : void
		{
			var error_code:String;
			var json:* = undefined;
			/*
			try
			{
			json = JSON.decode(data);
			}
			catch(e:Error)
			{
			json = {
			"error_code":0,
			"error_message":e.message
			};
			}
			*/
			error_code = json["error_code"];
			if(error_code == "0")
			{
				this.result = json["data"];
				if(Boolean(this.result.hasOwnProperty("uid")))
				{
					this.UserId = Number(this.result["uid"]);
				}
				onAnalyzeComplete();
			}
			else
			{
				message = json["error_message"];
				onAnalyzeError();
			}
		}
	}
}

