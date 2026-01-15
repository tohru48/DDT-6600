package email.data
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import flash.utils.Dictionary;
   
   public class EmailInfo
   {
      
      public var ID:int;
      
      public var UserID:int;
      
      public var MailType:int;
      
      public var Content:String = "";
      
      public var Title:String = "";
      
      public var Sender:String = "";
      
      public var SenderID:int;
      
      public var ReceiverID:int;
      
      public var SendTime:String;
      
      public var Annexs:Dictionary;
      
      public var Annex1:InventoryItemInfo;
      
      public var Annex2:InventoryItemInfo;
      
      public var Annex3:InventoryItemInfo;
      
      public var Annex4:InventoryItemInfo;
      
      public var Annex5:InventoryItemInfo;
      
      public var Annex1ID:int;
      
      public var Annex2ID:int;
      
      public var Annex3ID:int;
      
      public var Annex4ID:int;
      
      public var Annex5ID:int;
      
      public var Gold:Number = 500;
      
      public var Money:Number = 600;
      
      public var BindMoney:Number = 0;
      
      public var ValidDate:int = 30;
      
      public var Type:int = 0;
      
      public var IsRead:Boolean = false;
      
      public function EmailInfo()
      {
         super();
      }
      
      public function getAnnexs() : Array
      {
         var result:Array = new Array();
         if(Boolean(this.Annex1))
         {
            result.push(this.Annex1);
         }
         if(Boolean(this.Annex2))
         {
            result.push(this.Annex2);
         }
         if(Boolean(this.Annex3))
         {
            result.push(this.Annex3);
         }
         if(Boolean(this.Annex4))
         {
            result.push(this.Annex4);
         }
         if(Boolean(this.Annex5))
         {
            result.push(this.Annex5);
         }
         if(this.Gold != 0)
         {
            result.push("gold");
         }
         if(this.Money != 0)
         {
            result.push("money");
         }
         if(this.BindMoney != 0)
         {
            result.push("bindMoney");
         }
         return result;
      }
      
      public function get canReply() : Boolean
      {
         if(PlayerManager.Instance.Self.ID == this.SenderID)
         {
            return false;
         }
         switch(this.Type)
         {
            case 0:
            case 1:
            case 6:
            case 7:
            case 10:
            case 67:
            case 101:
            case EmailType.CONSORTION_EMAIL:
               return true;
            default:
               return false;
         }
      }
      
      public function getAnnexByIndex(index:int) : *
      {
         var result:* = undefined;
         var annexs:Array = this.getAnnexs();
         if(index > -1)
         {
            result = annexs[index];
         }
         return result;
      }
      
      public function hasAnnexs() : Boolean
      {
         if(Boolean(this.Annex1) || Boolean(this.Annex2) || Boolean(this.Annex3) || Boolean(this.Annex4) || Boolean(this.Annex5))
         {
            return true;
         }
         return false;
      }
   }
}

