package wonderfulActivity
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftConditionInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class WonderfulGMActAnalyer extends DataAnalyzer
   {
      
      private var _activityData:Dictionary;
      
      public function WonderfulGMActAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
         this._activityData = new Dictionary();
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var gmActivityData:GmActivityInfo = null;
         var giftbagArray:Array = null;
         var giftXml:XML = null;
         var giftItemList:XMLList = null;
         var j:int = 0;
         var giftBagInfo:GiftBagInfo = null;
         var giftConditionArr:Vector.<GiftConditionInfo> = null;
         var giftRewardArr:Vector.<GiftRewardInfo> = null;
         var giftConditionXMLList:XMLList = null;
         var m:int = 0;
         var giftConditionInfo:GiftConditionInfo = null;
         var giftRewardXMLList:XMLList = null;
         var n:int = 0;
         var giftRewardInfo:GiftRewardInfo = null;
         var isBind:int = 0;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..ActiveInfo;
            for(i = 0; i < xmllist.length(); i++)
            {
               gmActivityData = new GmActivityInfo();
               ObjectUtils.copyPorpertiesByXML(gmActivityData,xmllist[i].Activity[0]);
               gmActivityData.beginShowTime = gmActivityData.beginShowTime.replace(/-/g,"/");
               gmActivityData.beginTime = gmActivityData.beginTime.replace(/-/g,"/");
               gmActivityData.endShowTime = gmActivityData.endShowTime.replace(/-/g,"/");
               gmActivityData.endTime = gmActivityData.endTime.replace(/-/g,"/");
               giftbagArray = new Array();
               giftXml = xmllist[i].ActiveGiftBag[0];
               if(Boolean(giftXml))
               {
                  giftItemList = giftXml..Gift;
               }
               else
               {
                  giftItemList = null;
               }
               if(giftXml && giftItemList && giftItemList.length() > 0)
               {
                  for(j = 0; j < giftItemList.length(); j++)
                  {
                     giftBagInfo = new GiftBagInfo();
                     ObjectUtils.copyPorpertiesByXML(giftBagInfo,giftItemList[j]);
                     giftConditionArr = new Vector.<GiftConditionInfo>();
                     giftRewardArr = new Vector.<GiftRewardInfo>();
                     if(giftXml.ActiveCondition.length() > 0)
                     {
                        giftConditionXMLList = giftXml.ActiveCondition[j].Condition;
                        for(m = 0; m < giftConditionXMLList.length(); m++)
                        {
                           giftConditionInfo = new GiftConditionInfo();
                           ObjectUtils.copyPorpertiesByXML(giftConditionInfo,giftConditionXMLList[m]);
                           giftConditionArr.push(giftConditionInfo);
                        }
                     }
                     if(giftXml.ActiveReward.length() > 0)
                     {
                        giftRewardXMLList = giftXml.ActiveReward[j].Reward;
                        for(n = 0; n < giftRewardXMLList.length(); n++)
                        {
                           giftRewardInfo = new GiftRewardInfo();
                           ObjectUtils.copyPorpertiesByXML(giftRewardInfo,giftRewardXMLList[n]);
                           isBind = int(giftRewardXMLList[n].@isBind[0]);
                           giftRewardInfo.isBind = isBind == 1;
                           giftRewardArr.push(giftRewardInfo);
                        }
                     }
                     giftBagInfo.giftConditionArr = giftConditionArr;
                     giftBagInfo.giftRewardArr = giftRewardArr;
                     giftbagArray.push(giftBagInfo);
                  }
               }
               giftbagArray.sortOn("giftbagOrder",Array.NUMERIC);
               gmActivityData.giftbagArray = giftbagArray;
               this._activityData[gmActivityData.activityId] = gmActivityData;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get ActivityData() : Dictionary
      {
         return this._activityData;
      }
   }
}

