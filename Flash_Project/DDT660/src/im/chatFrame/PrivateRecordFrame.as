package im.chatFrame
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class PrivateRecordFrame extends Frame
   {
      
      public static const PAGE_MESSAGE:int = 20;
      
      public static const CLOSE:String = "close";
      
      private var _content:TextArea;
      
      private var _contentBG:ScaleBitmapImage;
      
      private var _close:TextButton;
      
      private var _messages:Vector.<Object>;
      
      private var _totalPage:int = 1;
      
      private var _currentPage:int;
      
      private var _pageBG:Bitmap;
      
      private var _firstPage:SimpleBitmapButton;
      
      private var _prePage:SimpleBitmapButton;
      
      private var _nextPage:SimpleBitmapButton;
      
      private var _lastPage:SimpleBitmapButton;
      
      private var _pageInput:TextInput;
      
      private var _pageWord:FilterFrameText;
      
      public function PrivateRecordFrame()
      {
         super();
         _titleText = LanguageMgr.GetTranslation("IM.ChatFrame.recordFrame.title");
         this._contentBG = ComponentFactory.Instance.creatComponentByStylename("recordFrame.contentBG");
         this._content = ComponentFactory.Instance.creatComponentByStylename("recordFrame.content");
         this._close = ComponentFactory.Instance.creatComponentByStylename("recordFrame.close");
         this._close.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
         this._pageBG = ComponentFactory.Instance.creatBitmap("asset.recordFrame.pageBG");
         this._firstPage = ComponentFactory.Instance.creatComponentByStylename("recordFrame.first");
         this._prePage = ComponentFactory.Instance.creatComponentByStylename("recordFrame.pre");
         this._nextPage = ComponentFactory.Instance.creatComponentByStylename("recordFrame.next");
         this._lastPage = ComponentFactory.Instance.creatComponentByStylename("recordFrame.last");
         this._pageInput = ComponentFactory.Instance.creatComponentByStylename("recordFrame.input");
         this._pageWord = ComponentFactory.Instance.creatComponentByStylename("recordFrame.word");
         addToContent(this._contentBG);
         addToContent(this._content);
         addToContent(this._close);
         addToContent(this._pageBG);
         addToContent(this._firstPage);
         addToContent(this._prePage);
         addToContent(this._nextPage);
         addToContent(this._lastPage);
         addToContent(this._pageInput);
         addToContent(this._pageWord);
         this._pageInput.textField.maxChars = 4;
         this._pageInput.textField.restrict = "0-9";
         this._close.addEventListener(MouseEvent.CLICK,this.__closeHandler);
         this._pageInput.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._firstPage.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._prePage.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._nextPage.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._lastPage.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._messages = new Vector.<Object>();
      }
      
      protected function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.currentTarget)
         {
            case this._firstPage:
               this.showPage(this._totalPage);
               break;
            case this._prePage:
               if(this._currentPage < this._totalPage)
               {
                  this.showPage(this._currentPage + 1);
               }
               break;
            case this._nextPage:
               if(this._currentPage > 1)
               {
                  this.showPage(this._currentPage - 1);
               }
               break;
            case this._lastPage:
               this.showPage(1);
         }
      }
      
      protected function __keyDownHandler(event:KeyboardEvent) : void
      {
         var num:int = 0;
         if(event.keyCode == Keyboard.ENTER)
         {
            SoundManager.instance.play("008");
            num = parseInt(this._pageInput.text);
            if(num > this._totalPage)
            {
               num = this._totalPage;
            }
            else if(num < 1)
            {
               num = 1;
            }
            this.showPage(this._totalPage + 1 - num);
         }
      }
      
      protected function __closeHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(CLOSE));
      }
      
      public function set playerId(id:int) : void
      {
         if(Boolean(SharedManager.Instance.privateChatRecord[id]))
         {
            this._messages = SharedManager.Instance.privateChatRecord[id];
         }
         else
         {
            this._messages = new Vector.<Object>();
         }
         this._totalPage = this._messages.length % PAGE_MESSAGE == 0 ? int(this._messages.length / PAGE_MESSAGE) : int(this._messages.length / PAGE_MESSAGE) + 1;
         this._totalPage = this._totalPage == 0 ? 1 : this._totalPage;
         this._pageWord.text = LanguageMgr.GetTranslation("IM.ChatFrame.recordFrame.pageWord",this._totalPage);
         this.showPage(1);
      }
      
      private function showPage(page:int) : void
      {
         if(page == 1)
         {
            this._lastPage.enable = false;
            this._nextPage.enable = false;
         }
         else
         {
            this._lastPage.enable = true;
            this._nextPage.enable = true;
         }
         if(page == this._totalPage)
         {
            this._firstPage.enable = false;
            this._prePage.enable = false;
         }
         else
         {
            this._firstPage.enable = true;
            this._prePage.enable = true;
         }
         this._pageInput.text = (this._totalPage + 1 - page).toString();
         this._currentPage = page;
         var str:String = "";
         var begain:int = (this._totalPage - this._currentPage) * PAGE_MESSAGE;
         var end:int = (this._totalPage - this._currentPage + 1) * PAGE_MESSAGE;
         begain = begain < 0 ? 0 : begain;
         end = end > this._messages.length ? int(this._messages.length) : end;
         for(var i:int = begain; i < end; i++)
         {
            str += String(this._messages[i]) + "<br/>";
         }
         this._content.htmlText = str;
         this._content.textField.setSelection(this._content.text.length - 1,this._content.text.length - 1);
         this._content.upScrollArea();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._close.removeEventListener(MouseEvent.CLICK,this.__closeHandler);
         this._pageInput.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._firstPage.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._prePage.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._nextPage.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._lastPage.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._messages = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
         if(Boolean(this._contentBG))
         {
            ObjectUtils.disposeObject(this._contentBG);
         }
         this._contentBG = null;
         if(Boolean(this._close))
         {
            ObjectUtils.disposeObject(this._close);
         }
         this._close = null;
         if(Boolean(this._pageBG))
         {
            ObjectUtils.disposeObject(this._pageBG);
         }
         this._pageBG = null;
         if(Boolean(this._firstPage))
         {
            ObjectUtils.disposeObject(this._firstPage);
         }
         this._firstPage = null;
         if(Boolean(this._prePage))
         {
            ObjectUtils.disposeObject(this._prePage);
         }
         this._prePage = null;
         if(Boolean(this._nextPage))
         {
            ObjectUtils.disposeObject(this._nextPage);
         }
         this._nextPage = null;
         if(Boolean(this._lastPage))
         {
            ObjectUtils.disposeObject(this._lastPage);
         }
         this._lastPage = null;
         if(Boolean(this._pageInput))
         {
            ObjectUtils.disposeObject(this._pageInput);
         }
         this._pageInput = null;
         if(Boolean(this._pageWord))
         {
            ObjectUtils.disposeObject(this._pageWord);
         }
         this._pageWord = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

