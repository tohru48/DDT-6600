package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemLeftView extends Sprite implements Disposeable
   {
      
      private var _windowBg:Bitmap;
      
      private var _pageBg:Bitmap;
      
      private var _pageTxtBg:Bitmap;
      
      private var _windowView:TotemLeftWindowView;
      
      private var _firstBtn:SimpleBitmapButton;
      
      private var _forwardBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _lastBtn:SimpleBitmapButton;
      
      private var _pageTxt:FilterFrameText;
      
      private var _currentPage:int = 1;
      
      private var _totalPage:int = 1;
      
      public function TotemLeftView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._windowBg = ComponentFactory.Instance.creatBitmap("asset.totem.leftView.windowBg");
         this._pageBg = ComponentFactory.Instance.creatBitmap("asset.totem.leftView.pageBg");
         this._pageTxtBg = ComponentFactory.Instance.creatBitmap("asset.totem.leftview.pageTxtBg");
         this._windowView = ComponentFactory.Instance.creatCustomObject("totemLeftWindowView");
         this._firstBtn = ComponentFactory.Instance.creatComponentByStylename("totem.leftView.page.firstBtn");
         this._forwardBtn = ComponentFactory.Instance.creatComponentByStylename("totem.leftView.page.forwardBtn");
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("totem.leftView.page.nextBtn");
         this._lastBtn = ComponentFactory.Instance.creatComponentByStylename("totem.leftView.page.lastBtn");
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("totem.leftView.pageTxt");
         var tmpNextInfo:TotemDataVo = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
         if(!tmpNextInfo)
         {
            this._currentPage = 5;
         }
         else
         {
            this._currentPage = tmpNextInfo.Page;
         }
         this.showPage();
         addChild(this._windowBg);
         addChild(this._pageBg);
         addChild(this._pageTxtBg);
         addChild(this._windowView);
         addChild(this._firstBtn);
         addChild(this._forwardBtn);
         addChild(this._nextBtn);
         addChild(this._lastBtn);
         addChild(this._pageTxt);
      }
      
      private function initEvent() : void
      {
         this._firstBtn.addEventListener(MouseEvent.CLICK,this.changePage);
         this._forwardBtn.addEventListener(MouseEvent.CLICK,this.changePage);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.changePage);
         this._lastBtn.addEventListener(MouseEvent.CLICK,this.changePage);
      }
      
      private function changePage(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var tmp:SimpleBitmapButton = event.currentTarget as SimpleBitmapButton;
         switch(tmp)
         {
            case this._firstBtn:
               this._currentPage = 1;
               break;
            case this._forwardBtn:
               --this._currentPage;
               if(this._currentPage < 1)
               {
                  this._currentPage = 1;
               }
               break;
            case this._nextBtn:
               ++this._currentPage;
               if(this._currentPage > this._totalPage)
               {
                  this._currentPage = this._totalPage;
               }
               break;
            case this._lastBtn:
               this._currentPage = this._totalPage;
         }
         this.showPage();
      }
      
      public function refreshView(isSuccess:Boolean) : void
      {
         var nextInfo:TotemDataVo = null;
         var nextInfo2:TotemDataVo = null;
         if(isSuccess)
         {
            nextInfo = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
            if(nextInfo && nextInfo.Page != 1 && nextInfo.Layers == 1 && nextInfo.Location == 1)
            {
               this._windowView.refreshView(nextInfo,this.openSuccessAutoNextPage);
            }
            else
            {
               this._windowView.refreshView(nextInfo);
               this.refreshPageBtn();
            }
         }
         else
         {
            nextInfo2 = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
            this._windowView.openFailHandler(nextInfo2);
         }
      }
      
      private function openSuccessAutoNextPage() : void
      {
         ++this._currentPage;
         this.showPage();
      }
      
      private function refreshPageBtn() : void
      {
         var tmp:int = TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId);
         this._totalPage = tmp / 70 + 1;
         this._totalPage = this._totalPage > 5 ? 5 : this._totalPage;
         if(this._currentPage == this._totalPage)
         {
            this._nextBtn.enable = false;
            this._lastBtn.enable = false;
         }
         else
         {
            this._nextBtn.enable = true;
            this._lastBtn.enable = true;
         }
         if(this._currentPage == 1)
         {
            this._firstBtn.enable = false;
            this._forwardBtn.enable = false;
         }
         else
         {
            this._firstBtn.enable = true;
            this._forwardBtn.enable = true;
         }
      }
      
      private function showPage() : void
      {
         this.refreshPageBtn();
         this._pageTxt.text = this._currentPage.toString();
         this._windowView.show(this._currentPage,TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId),true);
      }
      
      private function removeEvent() : void
      {
         this._firstBtn.removeEventListener(MouseEvent.CLICK,this.changePage);
         this._forwardBtn.removeEventListener(MouseEvent.CLICK,this.changePage);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.changePage);
         this._lastBtn.removeEventListener(MouseEvent.CLICK,this.changePage);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._windowBg = null;
         this._pageBg = null;
         this._pageTxtBg = null;
         this._windowView = null;
         this._firstBtn = null;
         this._forwardBtn = null;
         this._nextBtn = null;
         this._lastBtn = null;
         this._pageTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

