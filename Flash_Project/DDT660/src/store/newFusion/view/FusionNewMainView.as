package store.newFusion.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import store.HelpFrame;
   import store.IStoreViewBG;
   
   public class FusionNewMainView extends Sprite implements IStoreViewBG
   {
      
      private var _leftBg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _listPanel:ScrollPanel;
      
      private var _unitList:Vector.<FusionNewUnitView>;
      
      private var _rightView:FusionNewRightView;
      
      private var _canFusionSCB:SelectedCheckButton;
      
      private var _helpBtn:BaseButton;
      
      public function FusionNewMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var unitView:FusionNewUnitView = null;
         this._leftBg = ComponentFactory.Instance.creatBitmap("asset.newFusion.leftBg");
         this._rightView = new FusionNewRightView();
         PositionUtils.setPos(this._rightView,"store.newFusion.mainView.rightViewPos");
         this._canFusionSCB = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.canFusionSCB");
         this._vbox = new VBox();
         this._vbox.spacing = 2;
         this._unitList = new Vector.<FusionNewUnitView>();
         for(var i:int = 1; i <= 6; i++)
         {
            unitView = new FusionNewUnitView(i,this._rightView);
            unitView.addEventListener(FusionNewUnitView.SELECTED_CHANGE,this.refreshView,false,0,true);
            this._vbox.addChild(unitView);
            this._unitList.push(unitView);
         }
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.unitScrollPanel");
         this._listPanel.setView(this._vbox);
         this._listPanel.invalidateViewport();
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.HelpButton");
         addChild(this._leftBg);
         addChild(this._listPanel);
         addChild(this._canFusionSCB);
         addChild(this._helpBtn);
         addChild(this._rightView);
      }
      
      private function initEvent() : void
      {
         this._canFusionSCB.addEventListener(MouseEvent.CLICK,this.canFusionChangeHandler,false,0,true);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.helpBtnClickHandler,false,0,true);
      }
      
      private function helpBtnClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("store.newFusion.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("store.newFusion.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function canFusionChangeHandler(event:MouseEvent) : void
      {
         var tmp:FusionNewUnitView = null;
         SoundManager.instance.play("008");
         for each(tmp in this._unitList)
         {
            tmp.isFilter = this._canFusionSCB.selected;
         }
      }
      
      private function refreshView(event:Event) : void
      {
         var tmp:FusionNewUnitView = null;
         var tmpTargetUnit:FusionNewUnitView = event.target as FusionNewUnitView;
         for each(tmp in this._unitList)
         {
            if(tmp != tmpTargetUnit)
            {
               tmp.unextendHandler();
            }
         }
         this._vbox.arrange();
      }
      
      public function dragDrop(source:BagCell) : void
      {
      }
      
      public function refreshData(items:Dictionary) : void
      {
      }
      
      public function updateData() : void
      {
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._canFusionSCB))
         {
            this._canFusionSCB.removeEventListener(MouseEvent.CLICK,this.canFusionChangeHandler);
         }
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.helpBtnClickHandler);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._leftBg = null;
         this._vbox = null;
         this._listPanel = null;
         this._canFusionSCB = null;
         this._helpBtn = null;
         this._rightView = null;
         this._unitList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

