package email.view
{
   import com.pickgliss.ui.controls.container.VBox;
   import ddt.manager.LanguageMgr;
   import email.data.EmailInfo;
   import email.data.EmailType;
   import flash.events.Event;
   
   public class EmailListView extends VBox
   {
      
      private var _strips:Array;
      
      public function EmailListView()
      {
         super();
         this._strips = new Array();
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function update(emails:Array, isSendedMail:Boolean = false) : void
      {
         var strip:EmailStrip = null;
         this.clearElements();
         for(var i:uint = 0; i < emails.length; i++)
         {
            if(isSendedMail)
            {
               strip = new EmailStripSended();
            }
            else
            {
               strip = new EmailStrip();
            }
            strip.addEventListener(EmailStrip.SELECT,this.__select);
            strip.info = emails[i] as EmailInfo;
            if(strip.info.Title == LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionCellView.Object") && strip.info.Type == 9)
            {
               if(Boolean(strip.info.Annex1))
               {
                  strip.info.Annex1.ValidDate = -1;
               }
            }
            addChild(strip);
            this._strips.push(strip);
         }
         refreshChildPos();
      }
      
      public function switchSeleted() : void
      {
         if(this.allHasSelected() || this.isHaveConsortionMail())
         {
            this.changeAll(false);
            return;
         }
         this.changeAll(true);
      }
      
      private function allHasSelected() : Boolean
      {
         for(var i:uint = 0; i < this._strips.length; i++)
         {
            if(!(EmailStrip(this._strips[i]).info.Type == EmailType.ADVERT_MAIL || EmailStrip(this._strips[i]).info.Type == EmailType.CONSORTIONQUIT_EMAIL || EmailStrip(this._strips[i]).info.Type == 66))
            {
               if(!EmailStrip(this._strips[i]).selected)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      private function changeAll(value:Boolean) : void
      {
         for(var i:uint = 0; i < this._strips.length; i++)
         {
            EmailStrip(this._strips[i]).selected = value;
         }
      }
      
      private function isHaveConsortionMail() : Boolean
      {
         var s:EmailStrip = null;
         var vResult:Boolean = true;
         var sign:Boolean = false;
         for each(s in this._strips)
         {
            if(s.info.Type == EmailType.CONSORTION_EMAIL)
            {
               sign = true;
            }
            else if(!s.selected && s.info.Type != EmailType.CONSORTION_EMAIL)
            {
               vResult = false;
               break;
            }
         }
         return vResult && sign;
      }
      
      public function getSelectedMails() : Array
      {
         var tempArr:Array = [];
         for(var i:uint = 0; i < this._strips.length; i++)
         {
            if(EmailStrip(this._strips[i]).selected)
            {
               tempArr.push(EmailStrip(this._strips[i]).info);
            }
         }
         return tempArr;
      }
      
      public function updateInfo(info:EmailInfo) : void
      {
         var strip:EmailStrip = null;
         if(info == null)
         {
            return;
         }
         for each(strip in this._strips)
         {
            if(info == strip.info)
            {
               strip.info = info;
               break;
            }
         }
      }
      
      private function clearElements() : void
      {
         for(var i:int = 0; i < this._strips.length; i++)
         {
            this._strips[i].removeEventListener(EmailStrip.SELECT,this.__select);
            this._strips[i].dispose();
            this._strips[i] = null;
         }
         this._strips = new Array();
      }
      
      private function __select(event:Event) : void
      {
         var i:EmailStrip = null;
         var strip:EmailStrip = event.target as EmailStrip;
         for each(i in this._strips)
         {
            if(i != strip)
            {
               i.isReading = false;
            }
         }
      }
      
      internal function canChangePage() : Boolean
      {
         var i:EmailStrip = null;
         for each(i in this._strips)
         {
            if(i.emptyItem)
            {
               return false;
            }
         }
         return true;
      }
   }
}

