package newYearRice.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import newYearRice.NewYearRiceManager;
   import road7th.comm.PackageIn;
   
   public class NewYearRiceMainView extends Frame
   {
      
      public static const DINNER:int = 0;
      
      public static const BANQUET:int = 1;
      
      public static const HAN:int = 2;
      
      private var _openFrameView:NewYearRiceOpenFrameView;
      
      private var _main:MovieClip;
      
      private var _dinnerSelectedBtn:SelectedButton;
      
      private var _banquetSelectedBtn:SelectedButton;
      
      private var _hanSelectedBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _materialsBg:Bitmap;
      
      private var _rewardBg:Bitmap;
      
      private var _makeBtn:BaseButton;
      
      private var _materialsNum_1:FilterFrameText;
      
      private var _materialsNum_2:FilterFrameText;
      
      private var _materialsNum_3:FilterFrameText;
      
      private var _materialsNum_4:FilterFrameText;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _currentNum:Array;
      
      private var _maxNum:Array;
      
      private var _helpBtn:BaseButton;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var _selfInfo:SelfInfo;
      
      private var _price:int;
      
      private var _roomType:int;
      
      private var _psTxt:FilterFrameText;
      
      private var _alert1:BaseAlerFrame;
      
      private var _alert:BaseAlerFrame;
      
      private var _materialsArr:Array;
      
      public function NewYearRiceMainView()
      {
         super();
         this._selfInfo = PlayerManager.Instance.Self;
         this.initView();
         this.addEvnets();
      }
      
      private function initView() : void
      {
         this._main = ClassUtils.CreatInstance("asset.newYearRice.view") as MovieClip;
         PositionUtils.setPos(this._main,"asset.newYearRice.view.pos");
         addToContent(this._main);
         this._dinnerSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.dinnerSelectedBtn");
         addToContent(this._dinnerSelectedBtn);
         this._banquetSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.banquetSelectedBtn");
         addToContent(this._banquetSelectedBtn);
         this._hanSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.hanSelectedBtn");
         addToContent(this._hanSelectedBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._dinnerSelectedBtn);
         this._btnGroup.addSelectItem(this._banquetSelectedBtn);
         this._btnGroup.addSelectItem(this._hanSelectedBtn);
         this._btnGroup.selectIndex = DINNER;
         this._materialsBg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.MaterialsTxtBG");
         addToContent(this._materialsBg);
         this.showMaterials();
         this._materialsNum_1 = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.materialsNum_1");
         this._materialsNum_2 = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.materialsNum_2");
         this._materialsNum_3 = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.materialsNum_3");
         this._materialsNum_4 = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.materialsNum_4");
         addToContent(this._materialsNum_1);
         addToContent(this._materialsNum_2);
         addToContent(this._materialsNum_3);
         addToContent(this._materialsNum_4);
         this._psTxt = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.psTxt");
         this._psTxt.htmlText = LanguageMgr.GetTranslation("NewYearRiceMainView.psTxtLG");
         addToContent(this._psTxt);
         this._rewardBg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.RewardBg");
         addToContent(this._rewardBg);
         this._makeBtn = ComponentFactory.Instance.creat("NewYearRiceMainView.makeBtn");
         addToContent(this._makeBtn);
         this._helpBtn = ComponentFactory.Instance.creat("NewYearRiceMainView.helpBtn");
         addToContent(this._helpBtn);
         if(NewYearRiceManager.instance.model.yearFoodInfo > 0)
         {
            SocketManager.Instance.out.sendCheckMakeNewYearFood();
            return;
         }
         this.updateView(this._btnGroup.selectIndex);
      }
      
      private function addEvnets() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._makeBtn.addEventListener(MouseEvent.CLICK,this.__makeBtnHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpBtnHandler);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.YEARFOODCOOK,this.__yearFoodCook);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.YEARFOODENTER,this.__yearFoodEnter);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._makeBtn.removeEventListener(MouseEvent.CLICK,this.__makeBtnHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpBtnHandler);
         NewYearRiceManager.instance.removeEventListener(CrazyTankSocketEvent.YEARFOODCOOK,this.__yearFoodCook);
         NewYearRiceManager.instance.removeEventListener(CrazyTankSocketEvent.YEARFOODENTER,this.__yearFoodEnter);
      }
      
      private function __yearFoodCook(event:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.out.sendCheckMakeNewYearFood();
      }
      
      private function __yearFoodEnter(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._roomType = pkg.readInt();
         this._openFrameView = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.NewYearRiceOpenView");
         this._openFrameView.setViewFrame(this._roomType);
         this._openFrameView.roomPlayerItem(PlayerManager.Instance.Self.ID);
         LayerManager.Instance.addToLayer(this._openFrameView,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this.dispose();
      }
      
      private function __changeHandler(e:Event) : void
      {
         this.updateView(this._btnGroup.selectIndex);
      }
      
      private function updateView($selectIndex:int = 0) : void
      {
         this._currentNum = this.upDatafitCount(ServerConfigManager.instance.localYearFoodItems);
         switch($selectIndex)
         {
            case DINNER:
               this.showDinnerView();
               break;
            case BANQUET:
               this.showBanquetView();
               break;
            case HAN:
               this.showHanView();
         }
         if(Boolean(this._goodItemContainerAll))
         {
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
         }
         this._goodItemContainerAll = new Sprite();
         this._goodItemContainerAll.x = 29;
         this._goodItemContainerAll.y = -16;
         this.showGoods(NewYearRiceManager.instance.model.itemInfoList);
      }
      
      private function showDinnerView() : void
      {
         this._maxNum = ServerConfigManager.instance.localYearFoodItemsCount[0].toString().split(",");
         this.updateMaterialsText(this._currentNum,this._maxNum);
      }
      
      private function showBanquetView() : void
      {
         this._maxNum = ServerConfigManager.instance.localYearFoodItemsCount[1].toString().split(",");
         this.updateMaterialsText(this._currentNum,this._maxNum);
      }
      
      private function showHanView() : void
      {
         this._maxNum = ServerConfigManager.instance.localYearFoodItemsCount[2].toString().split(",");
         this.updateMaterialsText(this._currentNum,this._maxNum);
      }
      
      private function __makeBtnHandler(evt:MouseEvent) : void
      {
         var str:String = null;
         var priceArr:Array = null;
         var i:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._materialsArr.length > 0)
         {
            str = "";
            priceArr = ServerConfigManager.instance.localYearFoodItemsPrices;
            for(i = 0; i < this._materialsArr.length; i++)
            {
               switch(this._materialsArr[i].id)
               {
                  case 0:
                     str += "Mum x" + this._materialsArr[i].number + "  ";
                     this._price += int(priceArr[i]) * int(this._materialsArr[i].number);
                     break;
                  case 1:
                     str += "Krem x" + this._materialsArr[i].number + "  ";
                     this._price += int(priceArr[i]) * int(this._materialsArr[i].number);
                     break;
                  case 2:
                     str += "Buğday x" + this._materialsArr[i].number + "  ";
                     this._price += int(priceArr[i]) * int(this._materialsArr[i].number);
                     break;
                  case 3:
                     str += "Yumurta x" + this._materialsArr[i].number + "  ";
                     this._price += int(priceArr[i]) * int(this._materialsArr[i].number);
                     break;
               }
            }
            this._alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("NewYearRiceMainView.view.money",str,this._price),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,1);
            this._alert1.addEventListener(FrameEvent.RESPONSE,this.__makeNewYearRice);
         }
         else
         {
            SocketManager.Instance.out.makeNewYearRice(0,this._btnGroup.selectIndex,this._materialsArr);
         }
      }
      
      private function __makeNewYearRice(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__makeNewYearRice);
         alert.disposeChildren = true;
         alert.dispose();
         alert = null;
         if(e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < this._price)
            {
               this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               this._alert.moveEnable = false;
               this._alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
               return;
            }
            SocketManager.Instance.out.makeNewYearRice(1,this._btnGroup.selectIndex,this._materialsArr);
         }
         this._price = 0;
      }
      
      private function _responseI(e:FrameEvent) : void
      {
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function showMaterials() : void
      {
         var sprite:Sprite = null;
         var materialsBg:Bitmap = null;
         var materialsNum:Bitmap = null;
         for(var i:int = 0; i < 4; i++)
         {
            sprite = new Sprite();
            materialsBg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.MaterialsBG" + i);
            materialsNum = ComponentFactory.Instance.creatBitmap("asset.newYearRice.MaterialsNumFrame");
            sprite.addChild(materialsNum);
            sprite.addChild(materialsBg);
            addToContent(sprite);
            PositionUtils.setPos(sprite,"NewYearRiceMainView.Materials" + i);
         }
      }
      
      private function updateMaterialsText($currentArr:Array, $maxArr:Array) : void
      {
         var obj:Object = null;
         this._materialsArr = [];
         var k:int = 0;
         this._materialsNum_1.text = $currentArr[0] + "/" + $maxArr[0];
         this._materialsNum_2.text = $currentArr[1] + "/" + $maxArr[1];
         this._materialsNum_3.text = $currentArr[2] + "/" + $maxArr[2];
         this._materialsNum_4.text = $currentArr[3] + "/" + $maxArr[3];
         for(var i:int = 0; i < $maxArr.length; i++)
         {
            if($currentArr[i] < $maxArr[i])
            {
               obj = new Object();
               obj.number = $maxArr[i] - $currentArr[i];
               obj.id = i;
               this._materialsArr[k] = obj;
               k++;
               continue;
            }
            switch(i)
            {
               case 0:
                  this._materialsNum_1.text = $currentArr[0] + "/" + $maxArr[0];
                  this.setTFStyle(this._materialsNum_1);
                  break;
               case 1:
                  this._materialsNum_2.text = $currentArr[1] + "/" + $maxArr[1];
                  this.setTFStyle(this._materialsNum_2);
                  break;
               case 2:
                  this._materialsNum_3.text = $currentArr[2] + "/" + $maxArr[2];
                  this.setTFStyle(this._materialsNum_3);
                  break;
               case 3:
                  this._materialsNum_4.text = $currentArr[3] + "/" + $maxArr[3];
                  this.setTFStyle(this._materialsNum_4);
                  break;
            }
         }
      }
      
      public function upDatafitCount(id:Array) : Array
      {
         var conut:int = 0;
         var arr:Array = [];
         var bagInfo:BagInfo = this._selfInfo.getBag(BagInfo.PROPBAG);
         for(var i:int = 0; i < id.length; i++)
         {
            conut = bagInfo.getItemCountByTemplateId(id[i]);
            arr.push(conut);
         }
         return arr;
      }
      
      private function getMaterialsPrice(id:Array) : Array
      {
         var itemInfo:ItemTemplateInfo = null;
         var arr:Array = [];
         for(var i:int = 0; i < id.length; i++)
         {
            itemInfo = ItemManager.Instance.getTemplateById(id[i]) as ItemTemplateInfo;
            arr.push(itemInfo.Property3);
         }
         return arr;
      }
      
      private function setTFStyle($txt:FilterFrameText) : void
      {
         var mytf:TextFormat = new TextFormat();
         mytf.color = [16374016];
         $txt.setTextFormat(mytf,0,$txt.length);
      }
      
      private function showGoods(idArr:Array) : void
      {
         var index:int = 0;
         var bg:Bitmap = null;
         var dx:Number = NaN;
         var itemInfo:ItemTemplateInfo = null;
         var tInfo:InventoryItemInfo = null;
         var cell:BagCell = null;
         index = 0;
         var length:int = 0;
         for(var i:int = 0; i < idArr.length; i++)
         {
            bg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.GoodsFrame");
            dx = bg.width + 15;
            dx *= int(length % 6);
            bg.x = dx;
            bg.y = 243;
            itemInfo = ItemManager.Instance.getTemplateById(idArr[index].TemplateID) as ItemTemplateInfo;
            if(idArr[index].Quality != this._btnGroup.selectIndex + 1)
            {
               index++;
            }
            else
            {
               tInfo = new InventoryItemInfo();
               ObjectUtils.copyProperties(tInfo,itemInfo);
               tInfo.ValidDate = idArr[index].ValidDate;
               tInfo.StrengthenLevel = idArr[index].StrengthLevel;
               tInfo.AttackCompose = idArr[index].AttackCompose;
               tInfo.DefendCompose = idArr[index].DefendCompose;
               tInfo.LuckCompose = idArr[index].LuckCompose;
               tInfo.AgilityCompose = idArr[index].AgilityCompose;
               tInfo.IsBinds = idArr[index].IsBind;
               tInfo.Count = idArr[index].Count;
               cell = new BagCell(0,tInfo,false);
               cell.x = dx + 6;
               cell.y = 249;
               cell.setBgVisible(false);
               this._goodItemContainerAll.addChild(bg);
               this._goodItemContainerAll.addChild(cell);
               index++;
               length++;
            }
         }
         addToContent(this._goodItemContainerAll);
      }
      
      private function __helpBtnHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("NewYearRiceMainView.view.TexpView.helpTitle");
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("NewYearRiceMainView.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         if(Boolean(this._alert1))
         {
            ObjectUtils.disposeObject(this._alert1);
            this._alert1 = null;
         }
         if(Boolean(this._alert))
         {
            ObjectUtils.disposeObject(this._alert);
            this._alert = null;
         }
      }
   }
}

