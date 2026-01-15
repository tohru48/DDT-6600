package overSeasCommunity.vietnam.data
{
   public dynamic class FeedItem
   {
      
      private var _actId:int = 0;
      
      private var _userIdFrom:int = 0;
      
      private var _userIdTo:int = 0;
      
      private var _objectId:String = "";
      
      private var _attachName:String = "";
      
      private var _attachHref:String = "";
      
      private var _attachCaption:String = "";
      
      private var _attachDescription:String = "";
      
      private var _mediaType:int = 0;
      
      private var _mediaImage:String = "";
      
      private var _mediaSource:String = "";
      
      private var _actionLinkText:String = "";
      
      private var _actionLinkHref:String = "";
      
      private var _tplId:int = 0;
      
      public function FeedItem(userIdFrom:int, suggestion:Array, userIdTo:int, actId:int, templateId:int, objectId:String, attachName:String, attachHref:String, attachCaption:String, attachDescription:String, mediaType:int, mediaImage:String, mediaSource:String, actionLinkText:String, actionLinkHref:String)
      {
         super();
         this._userIdFrom = userIdFrom;
         this._userIdTo = userIdTo;
         this._actId = actId;
         this._tplId = templateId;
         this._objectId = objectId;
         this._attachName = attachName.length > 80 ? attachName.substring(0,80) : attachName;
         this._attachHref = attachHref.length > 150 ? attachHref.substring(0,150) : attachHref;
         this._attachCaption = attachCaption.length > 30 ? attachCaption.substring(0,30) : attachCaption;
         this._attachDescription = attachDescription.length > 200 ? attachDescription.substring(0,200) : attachDescription;
         this._mediaType = mediaType;
         this._mediaImage = mediaImage.length > 150 ? mediaImage.substring(0,150) : mediaImage;
         this._mediaSource = mediaSource.length > 150 ? mediaSource.substring(0,150) : mediaSource;
         this._actionLinkText = actionLinkText.length > 20 ? actionLinkText.substring(0,20) : actionLinkText;
         this._actionLinkHref = actionLinkHref.length > 150 ? actionLinkHref.substring(0,150) : actionLinkHref;
      }
      
      public function get userIdFrom() : int
      {
         return this._userIdFrom;
      }
      
      public function get userIdTo() : int
      {
         return this._userIdTo;
      }
      
      public function get actId() : int
      {
         return this._actId;
      }
      
      public function get tplId() : int
      {
         return this._tplId;
      }
      
      public function get objectId() : String
      {
         return this._objectId;
      }
      
      public function get attachName() : String
      {
         return this._attachName;
      }
      
      public function get attachHref() : String
      {
         return this._attachHref;
      }
      
      public function get attachCaption() : String
      {
         return this._attachCaption;
      }
      
      public function get attachDescription() : String
      {
         return this._attachDescription;
      }
      
      public function get mediaType() : int
      {
         return this._mediaType;
      }
      
      public function get mediaImage() : String
      {
         return this._mediaImage;
      }
      
      public function get mediaSource() : String
      {
         return this._mediaSource;
      }
      
      public function get actionLinkText() : String
      {
         return this._actionLinkText;
      }
      
      public function get actionLinkHref() : String
      {
         return this._actionLinkHref;
      }
   }
}

