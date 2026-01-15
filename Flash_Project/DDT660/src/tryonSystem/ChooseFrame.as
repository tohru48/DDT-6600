package tryonSystem
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import equipretrieve.effect.AnimationControl;
   import equipretrieve.effect.GlowFilterAnimation;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import quest.QuestRewardCell;
   import quest.TaskMainFrame;
   
   public class ChooseFrame extends BaseAlerFrame
   {
      
      private var _control:TryonSystemController;
      
      private var _bg:ScaleBitmapImage;
      
      private var _cells:Array;
      
      private var _list:SimpleTileList;
      
      private var _panel:ScrollPanel;
      
      public function ChooseFrame()
      {
         super();
         var alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.tryonSystem.title"),"","",true,false);
         alertInfo.submitLabel = LanguageMgr.GetTranslation("ok");
         alertInfo.moveEnable = false;
         info = alertInfo;
      }
      
      public function set controller($control:TryonSystemController) : void
      {
         this._control = $control;
         this.initView();
      }
      
      private function initView() : void
      {
         var animationControl:AnimationControl = null;
         var item:InventoryItemInfo = null;
         var cell:QuestRewardCell = null;
         var _itemShine:MovieImage = null;
         var animation:GlowFilterAnimation = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ChooseFrame.tryon.chooseItemBgAsset.bg");
         addToContent(this._bg);
         this._list = new SimpleTileList(2);
         this._list.hSpace = -7;
         this._list.vSpace = -5;
         PositionUtils.setPos(this._list,"ChooseFrame.SimpleTileList.pos");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("core.quest.ChooseFrame.scrollPanel");
         this._panel.setView(this._list);
         addToContent(this._panel);
         this._cells = [];
         animationControl = new AnimationControl();
         animationControl.addEventListener(Event.COMPLETE,this._cellLightComplete);
         for each(item in this._control.getModelByView(this).items)
         {
            cell = new QuestRewardCell();
            cell.opitional = true;
            cell.taskType = TaskMainFrame.NORMAL;
            cell.info = item;
            cell.addEventListener(MouseEvent.CLICK,this.__onclick);
            cell.buttonMode = true;
            this._cells.push(cell);
            this._list.addChild(cell);
            _itemShine = ComponentFactory.Instance.creatComponentByStylename("asset.core.itemShinelight");
            _itemShine.movie.play();
            cell.addChildAt(_itemShine,1);
            animation = new GlowFilterAnimation();
            animation.start(_itemShine,false,16763955,0,0);
            animation.addMovie(0,0,19,0);
            animationControl.addMovies(animation);
         }
         animationControl.startMovie();
      }
      
      private function _cellLightComplete(e:Event) : void
      {
         var len:int = 0;
         var i:int = 0;
         e.currentTarget.removeEventListener(Event.COMPLETE,this._cellLightComplete);
         if(Boolean(this._cells))
         {
            len = int(this._cells.length);
            for(i = 0; i < len; i++)
            {
               this._cells[i].removeChildAt(1);
            }
         }
      }
      
      private function __onclick(event:MouseEvent) : void
      {
         var cell:QuestRewardCell = null;
         SoundManager.instance.play("008");
         for each(cell in this._cells)
         {
            cell.selected = false;
         }
         this._control.getModelByView(this).selectedItem = QuestRewardCell(event.currentTarget).info;
         QuestRewardCell(event.currentTarget).selected = true;
      }
      
      override public function dispose() : void
      {
         var cell:QuestRewardCell = null;
         this._control = null;
         for each(cell in this._cells)
         {
            cell.removeEventListener(MouseEvent.CLICK,this.__onclick);
            cell.removeChildAt(1);
            cell.dispose();
         }
         this._cells = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         super.dispose();
      }
   }
}

