package farm.view.compose
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.control.FarmComposeHouseController;
   import farm.view.compose.event.SelectComposeItemEvent;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   
   public class ConfirmComposeFoodAlertFrame extends Frame
   {
      
      private var _bg3:Scale9CornerImage;
      
      private var _promptTxt:FilterFrameText;
      
      private var _showTxtBG:Image;
      
      private var _preBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _hBox:HBox;
      
      private var _cells:Vector.<ShopItemCell>;
      
      private var _cellInfos:Array;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      private var _currentImg:Bitmap;
      
      public function ConfirmComposeFoodAlertFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      private function initView() : void
      {
         var btn:BaseButton = null;
         var sp:Sprite = null;
         var itemCell:ShopItemCell = null;
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("farm.confirmComposeFoodAlertFrame.bg3");
         addToContent(this._bg3);
         this._showTxtBG = ComponentFactory.Instance.creatComponentByStylename("farm.confirmComposeFoodAlertFrame.showTxtBG");
         addToContent(this._showTxtBG);
         this._promptTxt = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.promptTxt");
         this._promptTxt.text = LanguageMgr.GetTranslation("ddt.farms.confirmComposeFoodAlertFrame.promptText");
         addToContent(this._promptTxt);
         escEnable = true;
         this._preBtn = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.btnPrePage1");
         addToContent(this._preBtn);
         this._nextBtn = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.btnNextPage1");
         addToContent(this._nextBtn);
         this._cells = new Vector.<ShopItemCell>();
         this._hBox = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.cropBox");
         addToContent(this._hBox);
         for(var i:int = 0; i < 3; i++)
         {
            btn = ComponentFactory.Instance.creatComponentByStylename("farmHouse.btnSelectHouseCompose3");
            sp = new Sprite();
            sp.graphics.beginFill(16777215,0);
            sp.graphics.drawRect(0,0,50,50);
            sp.graphics.endFill();
            itemCell = new ShopItemCell(sp);
            itemCell.cellSize = 50;
            btn.addEventListener(MouseEvent.CLICK,this.__selectValue);
            btn.mouseChildren = true;
            btn.addChild(itemCell);
            PositionUtils.setPos(itemCell,"farm.confirmComposeFoodAlertFrame.cellPos");
            this._hBox.addChild(btn);
            this._cells.push(itemCell);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
      }
      
      private function __onPageBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(e.currentTarget)
         {
            case this._preBtn:
               this._currentPage = this._currentPage - 1 < 0 ? 0 : this._currentPage - 1;
               break;
            case this._nextBtn:
               this._currentPage = this._currentPage + 1 > this._totlePage ? this._totlePage : this._currentPage + 1;
         }
         this.upCells(this._currentPage);
      }
      
      private function initData() : void
      {
         var itemInfoVec:Vector.<FoodComposeListTemplateInfo> = null;
         var foodId:int = 0;
         var info:ItemTemplateInfo = null;
         this._cellInfos = [];
         for each(itemInfoVec in FarmComposeHouseController.instance().composeHouseModel.foodComposeList)
         {
            foodId = itemInfoVec[0].FoodID;
            info = ItemManager.Instance.getTemplateById(foodId);
            this._cellInfos.push(info);
         }
         this._totlePage = this._cellInfos.length % 3 == 0 ? int(this._cellInfos.length / 3 - 1) : int(this._cellInfos.length / 3);
         this.upCells(0);
      }
      
      private function upCells(page:int = 0) : void
      {
         this._currentPage = page;
         var start:int = page * 3;
         for(var i:int = 0; i < this._cells.length; i++)
         {
            if(Boolean(this._cellInfos[i + start]))
            {
               this._cells[i].info = this._cellInfos[i + start];
            }
         }
      }
      
      private function __selectValue(e:MouseEvent) : void
      {
         var info:ItemTemplateInfo = null;
         var obj:Object = null;
         SoundManager.instance.play("008");
         var btn:BaseButton = e.currentTarget as BaseButton;
         for(var i:int = 0; i < btn.numChildren; i++)
         {
            obj = btn.getChildAt(i);
            if(obj is ShopItemCell)
            {
               info = obj.info;
               break;
            }
         }
         if(Boolean(info))
         {
            dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.SELECT_FOOD,info));
         }
      }
      
      protected function __framePesponse(event:FrameEvent) : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
      }
      
      override public function dispose() : void
      {
         var i:int = 0;
         var obj:Object = null;
         this.removeEvent();
         if(Boolean(this._hBox))
         {
            for(i = 0; i < this._hBox.numChildren; i++)
            {
               obj = this._hBox.getChildAt(i);
               if(obj is BaseButton)
               {
                  obj.removeEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
               }
            }
            this._hBox.disposeAllChildren();
            this._hBox.dispose();
            this._hBox = null;
         }
         if(Boolean(this._promptTxt))
         {
            ObjectUtils.disposeObject(this._promptTxt);
         }
         this._promptTxt = null;
         if(Boolean(this._bg3))
         {
            ObjectUtils.disposeObject(this._bg3);
         }
         this._bg3 = null;
         if(Boolean(this._showTxtBG))
         {
            ObjectUtils.disposeObject(this._showTxtBG);
         }
         this._showTxtBG = null;
         super.dispose();
      }
   }
}

