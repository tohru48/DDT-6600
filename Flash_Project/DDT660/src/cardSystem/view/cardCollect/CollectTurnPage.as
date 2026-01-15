package cardSystem.view.cardCollect
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CollectTurnPage extends Sprite implements Disposeable
   {
      
      private var _backGround:MovieImage;
      
      private var _pageBg:Scale9CornerImage;
      
      private var _preBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _pageText:FilterFrameText;
      
      private var _maxPage:int;
      
      private var _presentPage:int;
      
      public function CollectTurnPage()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set maxPage(value:int) : void
      {
         this._maxPage = value;
      }
      
      public function set page(value:int) : void
      {
         if(this._presentPage == value)
         {
            return;
         }
         this._presentPage = value;
         this._pageText.text = this._presentPage + "/" + this._maxPage;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get page() : int
      {
         return this._presentPage;
      }
      
      private function initView() : void
      {
         this._backGround = ComponentFactory.Instance.creatComponentByStylename("asset.turnPage.bg");
         this._pageBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtCardsList.PageCountBg");
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("TurnPage.prePageBtn");
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("TurnPage.nextPageBtn");
         this._pageText = ComponentFactory.Instance.creatComponentByStylename("TurnPage.pageText");
         addChild(this._backGround);
         addChild(this._pageBg);
         addChild(this._preBtn);
         addChild(this._nextBtn);
         addChild(this._pageText);
      }
      
      private function initEvent() : void
      {
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__prePage);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextPage);
      }
      
      private function removeEvent() : void
      {
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__prePage);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__nextPage);
      }
      
      protected function __prePage(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.page <= 1)
         {
            return;
         }
         --this.page;
      }
      
      protected function __nextPage(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.page >= this._maxPage)
         {
            return;
         }
         ++this.page;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._backGround))
         {
            ObjectUtils.disposeObject(this._backGround);
         }
         this._backGround = null;
         if(Boolean(this._pageBg))
         {
            ObjectUtils.disposeObject(this._pageBg);
         }
         this._pageBg = null;
         if(Boolean(this._preBtn))
         {
            ObjectUtils.disposeObject(this._preBtn);
         }
         this._preBtn = null;
         if(Boolean(this._nextBtn))
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         if(Boolean(this._pageText))
         {
            ObjectUtils.disposeObject(this._pageText);
         }
         this._pageText = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

