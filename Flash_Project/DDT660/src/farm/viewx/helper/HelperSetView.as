package farm.viewx.helper
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.view.compose.event.SelectComposeItemEvent;
   import farm.viewx.shop.FarmShopView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import shop.view.ShopItemCell;
   
   public class HelperSetView extends Frame
   {
      
      private static const MaxNum:int = 50;
      
      private var _titleBg:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _btmBg:ScaleBitmapImage;
      
      private var _ResetBtn:TextButton;
      
      private var _okBtn:TextButton;
      
      private var _Bg:ScaleBitmapImage;
      
      private var _SetBg:Scale9CornerImage;
      
      private var _SetBg1:Scale9CornerImage;
      
      private var _AddBtn:BaseButton;
      
      private var _AddBtn1:BaseButton;
      
      private var _MinusBtn:BaseButton;
      
      private var _MinusBtn1:BaseButton;
      
      private var _SetInputBg:Scale9CornerImage;
      
      private var _SetInputBg1:Scale9CornerImage;
      
      private var _setNumTxt:TextInput;
      
      private var _setNumTxt1:TextInput;
      
      private var _setNum:int = 0;
      
      private var _setFertilizerNum:int = 0;
      
      private var _NumerTxt:FilterFrameText;
      
      private var _NumerTxt1:FilterFrameText;
      
      private var _seedBtn:BaseButton;
      
      private var _FertilizerBtn:BaseButton;
      
      private var _seedSetBg:Bitmap;
      
      private var _fertilizerSetBg:Bitmap;
      
      private var _seedList:SeedSelect;
      
      private var _fertilizerList:FertilizerSelect;
      
      private var _result:ShopItemCell;
      
      private var _fertiliresult:ShopItemCell;
      
      private var _helperSetViewSelectResult:Function;
      
      private var _buyFrame:HelperBuyAlertFrame;
      
      private var seednum:int;
      
      private var manure:int;
      
      private var _farmShop:FarmShopView;
      
      private var _findNumState:Function;
      
      public function HelperSetView()
      {
         super();
         this.initView();
         this.addEvent();
         escEnable = true;
      }
      
      private function initView() : void
      {
         var sp1:Sprite = null;
         this._titleBg = ComponentFactory.Instance.creatBitmap("assets.farm.titleSmall");
         addToContent(this._titleBg);
         PositionUtils.setPos(this._titleBg,"farm.helperSettilte.Pos");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.farmShopPayPnlTitle");
         this._titleTxt.text = LanguageMgr.GetTranslation("ddt.farm.hepper.help.Set");
         addToContent(this._titleTxt);
         PositionUtils.setPos(this._titleTxt,"farm.helperSettilteTxt.Pos");
         this._btmBg = ComponentFactory.Instance.creatComponentByStylename("asset.farmheler.btmBimap");
         addToContent(this._btmBg);
         this._ResetBtn = ComponentFactory.Instance.creatComponentByStylename("farm.helper.ResetBtn");
         this._ResetBtn.text = LanguageMgr.GetTranslation("ddt.farm.hepper.help.Reset");
         addToContent(this._ResetBtn);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("farm.helper.okBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         addToContent(this._okBtn);
         this._Bg = ComponentFactory.Instance.creatComponentByStylename("asset.HelperSet.bg");
         addToContent(this._Bg);
         this._SetBg = ComponentFactory.Instance.creatComponentByStylename("asset.HelperSet.bgI");
         addToContent(this._SetBg);
         this._SetBg1 = ComponentFactory.Instance.creatComponentByStylename("asset.HelperSet.bgII");
         addToContent(this._SetBg1);
         this._AddBtn = ComponentFactory.Instance.creatComponentByStylename("helperSet.NumberAddBtn");
         addToContent(this._AddBtn);
         this._AddBtn1 = ComponentFactory.Instance.creatComponentByStylename("helperSet.NumberAddBtn");
         addToContent(this._AddBtn1);
         PositionUtils.setPos(this._AddBtn1,"farm.helperSetAddbtn.Pos");
         this._MinusBtn = ComponentFactory.Instance.creatComponentByStylename("helperSet.NumberMinuesBtn");
         addToContent(this._MinusBtn);
         this._MinusBtn1 = ComponentFactory.Instance.creatComponentByStylename("helperSet.NumberMinuesBtn");
         addToContent(this._MinusBtn1);
         PositionUtils.setPos(this._MinusBtn1,"farm.helperSetMinues.Pos");
         this._SetInputBg = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SetInputBg");
         addToContent(this._SetInputBg);
         this._SetInputBg1 = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SetInputBg");
         addToContent(this._SetInputBg1);
         PositionUtils.setPos(this._SetInputBg1,"farm.helper.SetInputBg.Pos");
         this._setNumTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.SetNumInput");
         addToContent(this._setNumTxt);
         this._setNumTxt.textField.restrict = "0-9";
         this._setNumTxt1 = ComponentFactory.Instance.creatComponentByStylename("farm.text.SetNumInput");
         addToContent(this._setNumTxt1);
         PositionUtils.setPos(this._setNumTxt1,"farm.helper.SetInputTxt.Pos");
         this._setNumTxt1.textField.restrict = "0-9";
         this._setNum = 0;
         this._setFertilizerNum = 0;
         this._NumerTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.NumText");
         this._NumerTxt1 = ComponentFactory.Instance.creatComponentByStylename("farm.text.NumText");
         this._NumerTxt.text = this._NumerTxt1.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.num");
         PositionUtils.setPos(this._NumerTxt1,"farm.helper.NumberTxt.Pos");
         addToContent(this._NumerTxt);
         addToContent(this._NumerTxt1);
         this._seedBtn = ComponentFactory.Instance.creatComponentByStylename("helperSet.SeedBtn");
         addToContent(this._seedBtn);
         this._FertilizerBtn = ComponentFactory.Instance.creatComponentByStylename("helperSet.FertilizerBtn");
         addToContent(this._FertilizerBtn);
         this._seedSetBg = ComponentFactory.Instance.creatBitmap("asset.farmHelper.SetBg1");
         this._fertilizerSetBg = ComponentFactory.Instance.creatBitmap("asset.farmHelper.SetBg");
         this._seedList = new SeedSelect();
         this._fertilizerList = new FertilizerSelect();
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,50,50);
         sp.graphics.endFill();
         sp1 = new Sprite();
         sp1.graphics.beginFill(16777215,0);
         sp1.graphics.drawRect(0,0,50,50);
         sp1.graphics.endFill();
         this._result = new ShopItemCell(sp,null,false,true);
         this._result.cellSize = 50;
         PositionUtils.setPos(this._result,"farm.helper.cellPos");
         this._seedBtn.addChild(this._result);
         this._seedBtn.mouseChildren = true;
         this._fertiliresult = new ShopItemCell(sp1);
         this._fertiliresult.cellSize = 50;
         PositionUtils.setPos(this._fertiliresult,"farm.helper.cellPos");
         this._FertilizerBtn.addChild(this._fertiliresult);
         this._FertilizerBtn.mouseChildren = true;
      }
      
      public function set helperSetViewSelectResult(value:Function) : void
      {
         this._helperSetViewSelectResult = value;
      }
      
      public function update(seedName:FilterFrameText, seednum:FilterFrameText, ferName:FilterFrameText, ferNum:FilterFrameText) : void
      {
         var itemInfo:ShopItemInfo = null;
         var itemInfo1:ShopItemInfo = null;
         var arr:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         var _seedInfos:Dictionary = new Dictionary();
         var _fertilizerInfos:Dictionary = new Dictionary();
         for(var i:int = 0; i < arr.length; i++)
         {
            itemInfo = arr[i];
            _seedInfos[itemInfo.TemplateInfo.Name] = itemInfo.TemplateInfo.TemplateID;
         }
         var arr1:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_MANURE_TYPE);
         for(var k:int = 0; k < arr1.length; k++)
         {
            itemInfo1 = arr1[k];
            _fertilizerInfos[itemInfo1.TemplateInfo.Name] = itemInfo1.TemplateInfo.TemplateID;
         }
         var SeedId:int = int(_seedInfos[seedName.text]);
         var fertilizerId:int = int(_fertilizerInfos[ferName.text]);
         this._result.info = ItemManager.Instance.getTemplateById(SeedId);
         this._fertiliresult.info = ItemManager.Instance.getTemplateById(fertilizerId);
         if(this._result.info == null)
         {
            this._AddBtn.enable = false;
            this._MinusBtn.enable = false;
         }
         else
         {
            this._AddBtn.enable = true;
            this._MinusBtn.enable = true;
         }
         if(this._fertiliresult.info == null)
         {
            this._AddBtn1.enable = false;
            this._MinusBtn1.enable = false;
         }
         else
         {
            this._AddBtn1.enable = true;
            this._MinusBtn1.enable = true;
         }
         this._setNumTxt.text = seednum.text;
         this._setNum = int(seednum.text);
         this._setNumTxt1.text = ferNum.text;
         this._setFertilizerNum = int(ferNum.text);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameHandler);
         this._AddBtn.addEventListener(MouseEvent.CLICK,this.__selectNum);
         this._AddBtn1.addEventListener(MouseEvent.CLICK,this.__selectNum);
         this._MinusBtn.addEventListener(MouseEvent.CLICK,this.__selectNum);
         this._MinusBtn1.addEventListener(MouseEvent.CLICK,this.__selectNum);
         this._setNumTxt.addEventListener(Event.CHANGE,this.__txtchange);
         this._setNumTxt1.addEventListener(Event.CHANGE,this.__txtchange1);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okHandler);
         this._ResetBtn.addEventListener(MouseEvent.CLICK,this.__resetHandler);
         this._seedBtn.addEventListener(MouseEvent.CLICK,this.__seedHandler);
         this._FertilizerBtn.addEventListener(MouseEvent.CLICK,this.__fertiliHandler);
         this._seedList.addEventListener(SelectComposeItemEvent.SELECT_SEED,this.__setseed);
         this._fertilizerList.addEventListener(SelectComposeItemEvent.SELECT_FERTILIZER,this.__setfertilizer);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameHandler);
         this._AddBtn.removeEventListener(MouseEvent.CLICK,this.__selectNum);
         this._AddBtn1.removeEventListener(MouseEvent.CLICK,this.__selectNum);
         this._MinusBtn.removeEventListener(MouseEvent.CLICK,this.__selectNum);
         this._MinusBtn1.removeEventListener(MouseEvent.CLICK,this.__selectNum);
         this._setNumTxt.removeEventListener(Event.CHANGE,this.__txtchange);
         this._setNumTxt1.removeEventListener(Event.CHANGE,this.__txtchange1);
         this._ResetBtn.removeEventListener(MouseEvent.CLICK,this.__resetHandler);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okHandler);
         this._seedBtn.removeEventListener(MouseEvent.CLICK,this.__seedHandler);
         this._FertilizerBtn.removeEventListener(MouseEvent.CLICK,this.__fertiliHandler);
         this._seedList.removeEventListener(SelectComposeItemEvent.SELECT_SEED,this.__setseed);
         this._fertilizerList.removeEventListener(SelectComposeItemEvent.SELECT_FERTILIZER,this.__setfertilizer);
      }
      
      private function __txtchange(event:Event) : void
      {
         this._setNum = parseInt(this._setNumTxt.text);
         this.checkInput();
      }
      
      private function __txtchange1(event:Event) : void
      {
         this._setFertilizerNum = parseInt(this._setNumTxt1.text);
         this.checkInputOne();
      }
      
      private function __selectNum(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.currentTarget)
         {
            case this._AddBtn:
               ++this._setNum;
               this.checkInput();
               break;
            case this._AddBtn1:
               ++this._setFertilizerNum;
               this.checkInputOne();
               break;
            case this._MinusBtn:
               if(this._setNum < 1)
               {
                  this._setNum == 1;
               }
               else
               {
                  --this._setNum;
               }
               this.checkInput();
               break;
            case this._MinusBtn1:
               if(this._setFertilizerNum < 1)
               {
                  this._setFertilizerNum == 1;
               }
               else
               {
                  --this._setFertilizerNum;
               }
               this.checkInputOne();
         }
      }
      
      private function __resetHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._setNumTxt.text = "0";
         this._setNumTxt1.text = "0";
         this._setNum = 0;
         this._setFertilizerNum = 0;
         if(Boolean(this._result.info))
         {
            this._result.info = ItemManager.Instance.getTemplateById(0);
         }
         if(Boolean(this._fertiliresult.info))
         {
            this._fertiliresult.info = ItemManager.Instance.getTemplateById(0);
         }
         this._AddBtn.enable = false;
         this._AddBtn1.enable = false;
         this._MinusBtn.enable = false;
         this._MinusBtn1.enable = false;
      }
      
      private function __okHandler(evnet:MouseEvent) : void
      {
         var seedId:Object = null;
         var manureId:Object = null;
         SoundManager.instance.play("008");
         this.seednum = int(this._setNumTxt.text);
         this.manure = int(this._setNumTxt1.text);
         var isSetSeed:Boolean = false;
         var isSetManure:Boolean = false;
         var seedinfo:InventoryItemInfo = null;
         var fertilizerinfo:InventoryItemInfo = null;
         if(Boolean(this._result.info))
         {
            seedinfo = FarmModelController.instance.model.findItemInfo(EquipType.SEED,this._result.info.TemplateID);
         }
         if(Boolean(this._fertiliresult.info))
         {
            fertilizerinfo = FarmModelController.instance.model.findItemInfo(EquipType.MANURE,this._fertiliresult.info.TemplateID);
         }
         if(Boolean(seedinfo))
         {
            if(seedinfo.CategoryID == EquipType.SEED && seedinfo.Count < this.seednum)
            {
               this.buyAlert();
               return;
            }
            if(this.seednum == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helper.SetTxt3"));
               return;
            }
         }
         if(seedinfo == null && this.seednum > 0)
         {
            this.buyAlert();
            return;
         }
         if(fertilizerinfo == null && this.manure > 0)
         {
            this.buyAlert();
            return;
         }
         if(Boolean(fertilizerinfo))
         {
            if(fertilizerinfo.CategoryID == EquipType.MANURE && fertilizerinfo.Count < this.manure)
            {
               this.buyAlert();
               return;
            }
            if(this.manure == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helper.SetTxt4"));
               return;
            }
         }
         var obj:Object = new Object();
         if(Boolean(this._result.info))
         {
            isSetSeed = true;
            obj.seedId = this._result.info.TemplateID;
            obj.seedNum = this.seednum;
         }
         if(Boolean(this._fertiliresult.info))
         {
            isSetManure = true;
            obj.manureId = this._fertiliresult.info.TemplateID;
            obj.manureNum = this.manure;
         }
         obj.isSeed = isSetSeed;
         obj.isManure = isSetManure;
         if(this._findNumState != null)
         {
            seedId = obj.seedId;
            if(!seedId)
            {
               seedId = 0;
            }
            manureId = obj.manureId;
            if(!manureId)
            {
               manureId = 0;
            }
            if(this._findNumState.call(this,seedId,manureId) > 0)
            {
               this.buyAlert();
               return;
            }
         }
         if(this._helperSetViewSelectResult != null)
         {
            this._helperSetViewSelectResult.call(this,obj);
         }
         this.dispose();
      }
      
      private function buyAlert() : void
      {
         this._buyFrame = ComponentFactory.Instance.creatComponentByStylename("farm.HelperBuyAlertFrame.confirmBuy");
         LayerManager.Instance.addToLayer(this._buyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._buyFrame.addEventListener(FrameEvent.RESPONSE,this.__onBuyResponse);
      }
      
      private function __onBuyResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._buyFrame.removeEventListener(FrameEvent.RESPONSE,this.__onBuyResponse);
         this._buyFrame.dispose();
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this._farmShop = ComponentFactory.Instance.creatComponentByStylename("farm.farmShopView.shop");
            this._farmShop.addEventListener(FrameEvent.RESPONSE,this.__closeFarmShop);
            this._farmShop.show();
            this._buyFrame.dispose();
         }
      }
      
      private function __closeFarmShop(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._farmShop.removeEventListener(FrameEvent.RESPONSE,this.__closeFarmShop);
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               ObjectUtils.disposeObject(this._farmShop);
               this._farmShop = null;
         }
      }
      
      public function get getTxtNum1() : int
      {
         return this.seednum;
      }
      
      public function get getTxtNum2() : int
      {
         return this.manure;
      }
      
      public function get getTxtId1() : int
      {
         var id:int = 0;
         if(Boolean(this._result) && Boolean(this._result.info))
         {
            id = this._result.info.TemplateID;
         }
         return id;
      }
      
      public function get getTxtId2() : int
      {
         var id:int = 0;
         if(Boolean(this._fertiliresult) && Boolean(this._fertiliresult.info))
         {
            id = this._fertiliresult.info.TemplateID;
         }
         return id;
      }
      
      private function checkInput() : void
      {
         if(this._setNum < 1)
         {
            this._setNum = 0;
         }
         else if(this._setNum > MaxNum)
         {
            this._setNum = MaxNum;
         }
         this._setNumTxt.text = this._setNum.toString();
      }
      
      private function checkInputOne() : void
      {
         if(this._setFertilizerNum < 1)
         {
            this._setFertilizerNum = 0;
         }
         else if(this._setFertilizerNum > MaxNum)
         {
            this._setFertilizerNum = MaxNum;
         }
         this._setNumTxt1.text = this._setFertilizerNum.toString();
      }
      
      private function __frameHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function __seedHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var pos:Point = this._seedBtn.localToGlobal(new Point(-100,-60));
         this._seedList.x = pos.x;
         this._seedList.y = pos.y;
         this._seedList.setVisible = true;
      }
      
      private function __fertiliHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var pos:Point = this._FertilizerBtn.localToGlobal(new Point(-100,60));
         this._fertilizerList.x = pos.x;
         this._fertilizerList.y = pos.y;
         this._fertilizerList.setVisible = true;
      }
      
      private function __setseed(event:SelectComposeItemEvent) : void
      {
         var templateId:int = int(event.data.id);
         this._result.info = ItemManager.Instance.getTemplateById(templateId);
         this._AddBtn.enable = true;
         this._MinusBtn.enable = true;
      }
      
      private function __setfertilizer(event:SelectComposeItemEvent) : void
      {
         var templateId:int = int(event.data.id);
         this._fertiliresult.info = ItemManager.Instance.getTemplateById(templateId);
         this._AddBtn1.enable = true;
         this._MinusBtn1.enable = true;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function set findNumState(value:Function) : void
      {
         this._findNumState = value;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._titleBg))
         {
            ObjectUtils.disposeObject(this._titleBg);
            this._titleBg = null;
         }
         if(Boolean(this._SetBg))
         {
            ObjectUtils.disposeObject(this._SetBg);
            this._SetBg = null;
         }
         if(Boolean(this._SetBg1))
         {
            ObjectUtils.disposeObject(this._SetBg1);
            this._SetBg1 = null;
         }
         if(Boolean(this._AddBtn))
         {
            ObjectUtils.disposeObject(this._AddBtn);
            this._AddBtn = null;
         }
         if(Boolean(this._AddBtn1))
         {
            ObjectUtils.disposeObject(this._AddBtn1);
            this._AddBtn1 = null;
         }
         if(Boolean(this._MinusBtn))
         {
            ObjectUtils.disposeObject(this._MinusBtn);
            this._MinusBtn = null;
         }
         if(Boolean(this._MinusBtn1))
         {
            ObjectUtils.disposeObject(this._MinusBtn1);
            this._MinusBtn1 = null;
         }
         if(Boolean(this._SetInputBg))
         {
            ObjectUtils.disposeObject(this._SetInputBg);
            this._SetInputBg = null;
         }
         if(Boolean(this._SetInputBg1))
         {
            ObjectUtils.disposeObject(this._SetInputBg1);
            this._SetInputBg1 = null;
         }
         if(Boolean(this._setNumTxt))
         {
            ObjectUtils.disposeObject(this._setNumTxt);
            this._setNumTxt = null;
         }
         if(Boolean(this._setNumTxt1))
         {
            ObjectUtils.disposeObject(this._setNumTxt1);
            this._setNumTxt1 = null;
         }
         if(Boolean(this._NumerTxt))
         {
            ObjectUtils.disposeObject(this._NumerTxt);
            this._NumerTxt = null;
         }
         if(Boolean(this._NumerTxt1))
         {
            ObjectUtils.disposeObject(this._NumerTxt1);
            this._NumerTxt1 = null;
         }
         if(Boolean(this._seedBtn))
         {
            ObjectUtils.disposeObject(this._seedBtn);
            this._seedBtn = null;
         }
         if(Boolean(this._FertilizerBtn))
         {
            ObjectUtils.disposeObject(this._FertilizerBtn);
            this._FertilizerBtn = null;
         }
         if(Boolean(this._ResetBtn))
         {
            ObjectUtils.disposeObject(this._ResetBtn);
            this._ResetBtn = null;
         }
         if(Boolean(this._okBtn))
         {
            ObjectUtils.disposeObject(this._okBtn);
            this._okBtn = null;
         }
         if(Boolean(this._btmBg))
         {
            ObjectUtils.disposeObject(this._btmBg);
            this._btmBg = null;
         }
         if(this._helperSetViewSelectResult != null)
         {
            this._helperSetViewSelectResult = null;
         }
         this._findNumState = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

