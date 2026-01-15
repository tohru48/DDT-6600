package overSeasCommunity.vietnam.data
{
   import com.pickgliss.utils.MD5;
   
   public class FeedDialogAuthen
   {
      
      public function FeedDialogAuthen()
      {
         super();
      }
      
      public static function creatSignKey($secretkey:String, feedItem:FeedItem) : String
      {
         var strAuthKey:String = $secretkey + ":" + feedItem.userIdFrom + ":" + feedItem.userIdTo + ":" + feedItem.actId + ":" + feedItem.tplId + ":" + feedItem.objectId + ":" + feedItem.attachName + ":" + feedItem.attachHref + ":" + feedItem.attachCaption + ":" + feedItem.attachDescription + ":" + feedItem.mediaType + ":" + feedItem.mediaImage + ":" + feedItem.mediaSource + ":" + feedItem.actionLinkText + ":" + feedItem.actionLinkHref;
         return MD5.hash(strAuthKey);
      }
   }
}

