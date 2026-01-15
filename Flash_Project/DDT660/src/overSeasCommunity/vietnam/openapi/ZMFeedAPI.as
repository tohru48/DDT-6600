package overSeasCommunity.vietnam.openapi
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import overSeasCommunity.vietnam.data.FeedItem;
	
	public class ZMFeedAPI extends BaseZMOpenAPI
	{
		
		public var callbackArgs:*;
		
		public function ZMFeedAPI(onResponseCall:Function = null)
		{
			super(onResponseCall);
		}
		
		public function sendEmail(recipients:Array, subject:String, text:String) : void
		{
			var param:Dictionary = new Dictionary();
			//param["recipients"] = JSON.encode(recipients);
			param["subject"] = subject;
			param["text"] = text;
			callMethodASync("SendEmailToUsers",param);
		}
		
		public function sendEmailByTemplate(recipients:Array, template_bundle_id:String, template_data:Object) : void
		{
			var param:Dictionary = new Dictionary();
			//param["recipients"] = JSON.encode(recipients);
			param["template_bundle_id"] = template_bundle_id;
			//param["template_data"] = JSON.encode(template_data);
			callMethodASync("SendEmailByTemplate",param);
		}
		
		public function publish(template_bundle_id:int, template_data:Object) : void
		{
			var param:Dictionary = creatSeessionKey();
			param["template_bundle_id"] = String(template_bundle_id);
			//param["template_data"] = JSON.encode(template_data);
			callMethodASync("PublishUserAction",param);
		}
		
		public function pushAndUpload(image:BitmapData, desc:String) : void
		{
			var param:Dictionary = creatSeessionKey();
			param["template_bundle_id"] = 195;
			param["description"] = escape(desc);
			uploadPhoto(image,param);
		}
		
		public function creatSignKey(feedItem:FeedItem, args:*) : void
		{
			this.callbackArgs = args;
			var param:Dictionary = new Dictionary();
			//param["json"] = JSON.encode(feedItem);
			callMethodASync("SignkeyForJson",param);
		}
	}
}

