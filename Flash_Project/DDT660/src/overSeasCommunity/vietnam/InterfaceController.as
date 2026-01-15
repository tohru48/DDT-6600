package overSeasCommunity.vietnam
{
	//import com.adobe.serialization.json.JSON;
	import com.pickgliss.toplevel.StageReferance;
	import ddt.manager.LanguageMgr;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import overSeasCommunity.vietnam.data.FeedItem;
	import overSeasCommunity.vietnam.openapi.BaseZMOpenAPI;
	import overSeasCommunity.vietnam.openapi.ZMFeedAPI;
	import overSeasCommunity.vietnam.openapi.ZMRequestEvent;
	import overSeasCommunity.vietnam.openapi.ZMSessionAPI;
	import overSeasCommunity.vietnam.openapi.ZMUserAPI;
	
	public class InterfaceController extends EventDispatcher
	{
		
		private var _communityUserId:int;
		
		private var _secret_key:String;
		
		private var _pub_key:String;
		
		public function InterfaceController()
		{
			super();
		}
		
		public function setup() : void
		{
			BaseZMOpenAPI.session_id = StageReferance.stage.loaderInfo.parameters["sessionId"];
			var api:ZMSessionAPI = new ZMSessionAPI(this.onLoggedInUser);
			api.getLoggedInUser(BaseZMOpenAPI.session_id);
		}
		
		public function pushFeed(tpl_id:int, desc:String = "", imageSrc:String = "", titelItem:Array = null) : void
		{
			var feedItem:FeedItem = this.creatFeedItem(tpl_id,titelItem,desc,imageSrc);
			var api:ZMFeedAPI = new ZMFeedAPI();
			api.addEventListener(ZMRequestEvent.RESPONSE,this.__creatSignKey);
			api.creatSignKey(feedItem,titelItem);
		}
		
		private function __creatSignKey(e:ZMRequestEvent) : void
		{
			(e.target as ZMFeedAPI).removeEventListener(ZMRequestEvent.RESPONSE,this.__creatSignKey);
			var titleItem:Array = (e.target as ZMFeedAPI).callbackArgs;
			var result:* = e.result;
			result["itemTitle1"] = titleItem[0];
			result["itemTitle2"] = titleItem[1];
			result["itemTitle3"] = titleItem[2];
			//ExternalInterface.call("pushfeed",JSON.encode(result));
		}
		
		private function onCreatSignKey(result:*) : void
		{
			ExternalInterface.call("pushfeed",result);
		}
		
		private function creatFeedItem(tpl_id:int, titelItem:Array, attach_des:String, media_img:String) : FeedItem
		{
			var attach_name:String = LanguageMgr.GetTranslation("community.feed.attach_name");
			var attach_href:String = LanguageMgr.GetTranslation("community.feed.attach_href");
			var attach_caption:String = LanguageMgr.GetTranslation("community.feed.attach_caption");
			var actlink_href:String = LanguageMgr.GetTranslation("community.feed.actlink_href");
			return new FeedItem(this._communityUserId,titelItem,0,1,tpl_id,"",attach_name,attach_href,attach_caption,attach_des,1,media_img,actlink_href,"Link",actlink_href);
		}
		
		private function onLoggedInUser(userId:int) : void
		{
			this._communityUserId = userId;
		}
		
		public function pushAndComment(template_bundle_id:int, message:String, comment:String) : void
		{
		}
		
		public function sendNotice(userId:int, text:String) : void
		{
			var feed:ZMFeedAPI = new ZMFeedAPI();
			feed.sendEmail([userId],"",text);
		}
		
		public function loadSyncFriends() : void
		{
		}
		
		public function pushAndUpload(image:BitmapData, desc:String) : void
		{
			var feed:ZMFeedAPI = new ZMFeedAPI();
			feed.pushAndUpload(image,desc);
		}
		
		private function __uploadComplete(e:ZMRequestEvent) : void
		{
			(e.target as ZMFeedAPI).removeEventListener(ZMRequestEvent.RESPONSE,this.__uploadComplete);
			var desc:String = (e.target as ZMFeedAPI).callbackArgs;
			var imageLink:String = e.result["img-link"];
			ExternalInterface.call("alert",imageLink + " - " + desc);
		}
		
		public function leaveComment(friendId:int, message:String) : void
		{
			this.sendNotice(friendId,message);
		}
		
		public function checkAllowShareResume(loginName:String, callback:Function) : void
		{
			var cmuser:ZMUserAPI = new ZMUserAPI(callback);
			cmuser.getInfoByUsername(loginName,"");
		}
	}
}

import overSeasCommunity.vietnam.data.FeedItem;

class FeedJSONObject
{
	
	public var pub_key:String;
	
	public var sign_key:String;
	
	public var actId:int = 0;
	
	public var userIdFrom:int = 0;
	
	public var userIdTo:int = 0;
	
	public var objectId:String = "";
	
	public var attachName:String = "";
	
	public var attachHref:String = "";
	
	public var attachCaption:String = "";
	
	public var attachDescription:String = "";
	
	public var mediaType:int = 0;
	
	public var mediaImage:String = "";
	
	public var mediaSource:String = "";
	
	public var actionLinkText:String = "";
	
	public var actionLinkHref:String = "";
	
	public var tplId:int = 0;
	
	public function FeedJSONObject(item:FeedItem, _pub_key:String, _sign_key:String)
	{
		super();
		this.pub_key = _pub_key;
		this.sign_key = _sign_key;
		this.userIdFrom = item.userIdFrom;
		this.userIdTo = item.userIdTo;
		this.actId = item.actId;
		this.tplId = item.tplId;
		this.objectId = item.objectId;
		this.attachName = item.attachName;
		this.attachHref = item.attachHref;
		this.attachCaption = item.attachCaption;
		this.attachDescription = item.attachDescription;
		this.mediaType = item.mediaType;
		this.mediaImage = item.mediaImage;
		this.mediaSource = item.mediaSource;
		this.actionLinkText = item.actionLinkText;
		this.actionLinkHref = item.actionLinkHref;
	}
}
