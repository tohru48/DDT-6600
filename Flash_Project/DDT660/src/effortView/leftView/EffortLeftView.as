package effortView.leftView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.EffortEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import effortView.EffortController;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EffortLeftView extends Sprite implements Disposeable
   {
      
      public static const TITLE_NUM:int = 6;
      
      private var _effortCategoryTitleItem:EffortCategoryTitleItem;
      
      private var _effortCategoryTitleItemArray:Array;
      
      private var _controller:EffortController;
      
      private var _bg:MovieImage;
      
      private var _achievementPointText:FilterFrameText;
      
      public function EffortLeftView(controller:EffortController)
      {
         this._controller = controller;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var effortCategoryTitleItem:EffortCategoryTitleItem = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.Effort.effortLeftBg");
         addChild(this._bg);
         this._achievementPointText = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortMainFrame.AchievementPointText");
         if(EffortManager.Instance.isSelf)
         {
            this._achievementPointText.text = String(PlayerManager.Instance.Self.AchievementPoint);
            SocketManager.Instance.out.sendRequestUpdate();
         }
         else
         {
            this._achievementPointText.text = String(EffortManager.Instance.getTempAchievementPoint());
         }
         addChild(this._achievementPointText);
         this._effortCategoryTitleItemArray = [];
         for(var i:int = 0; i <= TITLE_NUM; i++)
         {
            effortCategoryTitleItem = new EffortCategoryTitleItem(i);
            effortCategoryTitleItem.y = i * 30;
            effortCategoryTitleItem.addEventListener(MouseEvent.CLICK,this.__CategoryTitleClick);
            this._effortCategoryTitleItemArray.push(effortCategoryTitleItem);
            addChild(effortCategoryTitleItem);
         }
         this._controller.currentRightViewType = this._controller.currentRightViewType;
         this.__rightChange();
      }
      
      private function __CategoryTitleClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._effortCategoryTitleItem)
         {
            this._effortCategoryTitleItem = evt.currentTarget as EffortCategoryTitleItem;
         }
         if(this._effortCategoryTitleItem != evt.currentTarget as EffortCategoryTitleItem)
         {
            this._effortCategoryTitleItem.selectState = false;
         }
         this._effortCategoryTitleItem = evt.currentTarget as EffortCategoryTitleItem;
         this._effortCategoryTitleItem.selectState = this._effortCategoryTitleItem.isExpand ? false : true;
         for(var j:int = 1; j <= TITLE_NUM; j++)
         {
            (this._effortCategoryTitleItemArray[j] as EffortCategoryTitleItem).y = j * 30;
         }
         if(this._controller.currentRightViewType != (evt.currentTarget as EffortCategoryTitleItem).currentType)
         {
            this._controller.currentRightViewType = (evt.currentTarget as EffortCategoryTitleItem).currentType;
         }
         this.__rightChange();
      }
      
      private function initEvent() : void
      {
         EffortManager.Instance.addEventListener(EffortEvent.TYPE_CHANGED,this.__typeChanged);
         this._controller.addEventListener(Event.CHANGE,this.__rightChange);
      }
      
      private function __rightChange(event:Event = null) : void
      {
         if(Boolean(this._effortCategoryTitleItem))
         {
            this._effortCategoryTitleItem.selectState = false;
         }
         this._effortCategoryTitleItem = this._effortCategoryTitleItemArray[this._controller.currentRightViewType] as EffortCategoryTitleItem;
         this._effortCategoryTitleItem.selectState = this._effortCategoryTitleItem.isExpand ? false : true;
      }
      
      private function disposeItem() : void
      {
         if(!this._effortCategoryTitleItemArray)
         {
            return;
         }
         for(var i:int = 0; i < this._effortCategoryTitleItemArray.length; i++)
         {
            (this._effortCategoryTitleItemArray[i] as EffortCategoryTitleItem).parent.removeChild(this._effortCategoryTitleItemArray[i] as EffortCategoryTitleItem);
            (this._effortCategoryTitleItemArray[i] as EffortCategoryTitleItem).removeEventListener(MouseEvent.CLICK,this.__CategoryTitleClick);
            (this._effortCategoryTitleItemArray[i] as EffortCategoryTitleItem).dispose();
            this._effortCategoryTitleItemArray[i] = null;
         }
      }
      
      private function __typeChanged(event:EffortEvent) : void
      {
         this._controller.currentRightViewType = this._controller.currentRightViewType;
      }
      
      public function dispose() : void
      {
         this.disposeItem();
         EffortManager.Instance.removeEventListener(EffortEvent.TYPE_CHANGED,this.__typeChanged);
         this._controller.removeEventListener(Event.CHANGE,this.__rightChange);
         if(Boolean(this._effortCategoryTitleItem))
         {
            this._effortCategoryTitleItem.dispose();
            this._effortCategoryTitleItem = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

