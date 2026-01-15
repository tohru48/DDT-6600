package farm.viewx.poultry
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   
   public class FarmTreeUpgrade extends BaseAlerFrame
   {
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _bg:Bitmap;
      
      private var _bg2:Bitmap;
      
      private var _titleImage:MutipleImage;
      
      private var _loveBg:BaseButton;
      
      private var _loveNum:FilterFrameText;
      
      private var _callBtn:BaseButton;
      
      private var _levelNum:int;
      
      private var _control:DisplayObject;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var _upgradingFlag:Boolean;
      
      public function FarmTreeUpgrade()
      {
         super();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.initFarmTree();
      }
      
      private function initView() : void
      {
         escEnable = true;
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("farm.treeUpgradeView.helpBtn");
         addToContent(this._helpBtn);
         this._titleImage = ComponentFactory.Instance.creatComponentByStylename("farm.treeUpgradeView.title");
         addToContent(this._titleImage);
         this._bg = ComponentFactory.Instance.creat("asset.farm.treeUpgrade.Bg");
         addToContent(this._bg);
         this._bg2 = ComponentFactory.Instance.creat("asset.farm.treeUpgrade.Bg2");
         addToContent(this._bg2);
         this._loveBg = ComponentFactory.Instance.creatComponentByStylename("farm.treeUpgradeView.loveNumBg");
         this._loveBg.tipData = LanguageMgr.GetTranslation("farm.farmUpgrade.loveNumTipsTxt");
         addToContent(this._loveBg);
         this._loveNum = ComponentFactory.Instance.creatComponentByStylename("farm.tree.loveNumTxt");
         addToContent(this._loveNum);
         this._callBtn = ComponentFactory.Instance.creatComponentByStylename("farm.treeUpgradeView.callBtn");
         this._callBtn.tipData = LanguageMgr.GetTranslation("farm.farmUpgrade.callBtnTxt");
         addToContent(this._callBtn);
         if(FarmModelController.instance.model.PoultryState > 0)
         {
            this._callBtn.enable = false;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__closeFarm);
         this._callBtn.addEventListener(MouseEvent.CLICK,this.__onCallBtnClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpBtnClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FARM_UPGRADEINITTREE,this.__onInitData);
         FarmModelController.instance.addEventListener(FarmEvent.FARMPOULTRY_SETCALLBTN,this.__onSetCallBtnEnable);
         FarmModelController.instance.addEventListener(FarmEvent.FARMPOULTRY_UPGRADING,this.__onUpgrading);
      }
      
      protected function __onUpgrading(event:FarmEvent) : void
      {
         this._upgradingFlag = event.obj[0];
      }
      
      protected function __onSetCallBtnEnable(event:FarmEvent) : void
      {
         this._callBtn.enable = false;
      }
      
      protected function __onInitData(event:CrazyTankSocketEvent) : void
      {
         var needExp:int = 0;
         var pkg:PackageIn = event.pkg;
         this._levelNum = pkg.readInt();
         var loveNum:int = pkg.readInt();
         var treeExp:int = pkg.readInt() - FarmModelController.instance.model.farmPoultryInfo[this._levelNum].Exp;
         var condenserExp:int = pkg.readInt();
         var needCondenserExp:int = int(FarmModelController.instance.model.farmPoultryInfo[this._levelNum].CostExp);
         FarmModelController.instance.model.FarmTreeLevel = this._levelNum;
         FarmModelController.instance.dispatchEvent(new FarmEvent(FarmEvent.FARMTREE_UPDATETREELEVEL));
         this._loveNum.text = loveNum.toString();
         if(this._levelNum > 0 && this._levelNum % 10 == 0 && treeExp == 0 && condenserExp < needCondenserExp)
         {
            if(Boolean(this._control))
            {
               if(this._control is TreeUpgradeWater)
               {
                  TreeUpgradeWater(this._control).dispose();
                  this._control = new TreeUpgradeCondenser();
               }
            }
            else
            {
               this._control = new TreeUpgradeCondenser();
            }
            TreeUpgradeCondenser(this._control).setExp(condenserExp,needCondenserExp,this._levelNum);
         }
         else
         {
            if(Boolean(this._control))
            {
               if(this._control is TreeUpgradeCondenser)
               {
                  TreeUpgradeCondenser(this._control).dispose();
                  this._control = new TreeUpgradeWater();
               }
            }
            else
            {
               this._control = new TreeUpgradeWater();
            }
            needExp = 0;
            if(this._levelNum >= 50)
            {
               needExp = 1;
               treeExp = 1;
            }
            else
            {
               needExp = FarmModelController.instance.model.farmPoultryInfo[this._levelNum + 1].Exp - FarmModelController.instance.model.farmPoultryInfo[this._levelNum].Exp;
            }
            TreeUpgradeWater(this._control).setLevelNum(this._levelNum);
            TreeUpgradeWater(this._control).setExp(treeExp,needExp);
            TreeUpgradeWater(this._control).setLoveNum(loveNum);
         }
         PositionUtils.setPos(this._control,"asset.farm.controlPos");
         addToContent(this._control);
      }
      
      protected function __onCallBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var callView:CallPoultryView = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.callView");
         LayerManager.Instance.addToLayer(callView,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __onHelpBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("ddt.consortia.bossFrame.helpTitle");
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("farm.treeUpgrade.helpInfo");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.btnOk");
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
      
      private function __closeFarm(event:FrameEvent) : void
      {
         if(!this._upgradingFlag)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__closeFarm);
         this._callBtn.removeEventListener(MouseEvent.CLICK,this.__onCallBtnClick);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpBtnClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FARM_UPGRADEINITTREE,this.__onInitData);
         FarmModelController.instance.removeEventListener(FarmEvent.FARMPOULTRY_SETCALLBTN,this.__onSetCallBtnEnable);
         FarmModelController.instance.removeEventListener(FarmEvent.FARMPOULTRY_UPGRADING,this.__onUpgrading);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._bg2))
         {
            this._bg2.bitmapData.dispose();
            this._bg2 = null;
         }
         if(Boolean(this._helpBtn))
         {
            ObjectUtils.disposeObject(this._helpBtn);
            this._helpBtn = null;
         }
         if(Boolean(this._loveBg))
         {
            this._loveBg.dispose();
            this._loveBg = null;
         }
         if(Boolean(this._titleImage))
         {
            this._titleImage.dispose();
            this._titleImage = null;
         }
         if(Boolean(this._loveNum))
         {
            this._loveNum.dispose();
            this._loveNum = null;
         }
         if(Boolean(this._callBtn))
         {
            this._callBtn.dispose();
            this._callBtn = null;
         }
         if(Boolean(this._helpFrame))
         {
            this._helpFrame.dispose();
            this._helpFrame = null;
         }
         super.dispose();
      }
   }
}

