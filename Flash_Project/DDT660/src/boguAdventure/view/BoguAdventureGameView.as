package boguAdventure.view
{
   import baglocked.BaglockedManager;
   import boguAdventure.BoguAdventureControl;
   import boguAdventure.cell.BoguAdventureCell;
   import boguAdventure.event.BoguAdventureEvent;
   import boguAdventure.model.BoguAdventureActionType;
   import boguAdventure.model.BoguAdventureCellInfo;
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   
   public class BoguAdventureGameView extends Sprite
   {
      
      private var _reviveBtn:SimpleBitmapButton;
      
      private var _awardBtn:SimpleBitmapButton;
      
      private var _arardBtnEffect:IEffect;
      
      private var _resetBtn:SimpleBitmapButton;
      
      private var _freeResetBtn:SimpleBitmapButton;
      
      private var _signBtn:SimpleBitmapButton;
      
      private var _findMineBtn:SimpleBitmapButton;
      
      private var _helpView:BoguAdventureHelpFrame;
      
      private var _mouseStyle:Bitmap;
      
      private var _control:BoguAdventureControl;
      
      private var _map:BoguAdventureMap;
      
      private var _changeView:BoguAdventureChangeView;
      
      private var _hpBox:HBox;
      
      private var _openCountBg:Bitmap;
      
      private var _openCountText:FilterFrameText;
      
      private var _limitResetText:FilterFrameText;
      
      private var _resetNumText:FilterFrameText;
      
      public function BoguAdventureGameView(control:BoguAdventureControl)
      {
         super();
         this._control = control;
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._map = new BoguAdventureMap(this._control);
         PositionUtils.setPos(this._map,"boguAdventure.view.mapContainerPos");
         this._map.mouseClickClose();
         addChild(this._map);
         this._changeView = new BoguAdventureChangeView(this._control);
         addChild(this._changeView);
         this._reviveBtn = UICreatShortcut.creatAndAdd("boguAdventure.toolRevive",this);
         this._reviveBtn.tipData = LanguageMgr.GetTranslation("boguAdventure.view.reviveBtnTip");
         this._reviveBtn.enable = false;
         this._awardBtn = UICreatShortcut.creatAndAdd("boguAdventure.toolGetAwardBtn",this);
         this._resetBtn = UICreatShortcut.creatAndAdd("boguAdventure.toolReset",this);
         this._resetBtn.tipData = LanguageMgr.GetTranslation("boguAdventure.view.resetBtnTip");
         this._freeResetBtn = UICreatShortcut.creatAndAdd("boguAdventure.toolFreeReset",this);
         this._freeResetBtn.tipData = LanguageMgr.GetTranslation("boguAdventure.view.resetBtnTip");
         this._signBtn = UICreatShortcut.creatAndAdd("boguAdventure.toolSign",this);
         this._signBtn.tipData = LanguageMgr.GetTranslation("boguAdventure.view.signBtnTip");
         this._findMineBtn = UICreatShortcut.creatAndAdd("boguAdventure.toolFindMine",this);
         this._findMineBtn.tipData = LanguageMgr.GetTranslation("boguAdventure.view.findMineBtnTip");
         this._helpView = UICreatShortcut.creatAndAdd("boguAdventure.view.helpFrame",this);
         this._mouseStyle = UICreatShortcut.creatAndAdd("boguAdventure.view.mouseStyle",this);
         this._mouseStyle.visible = false;
         this._hpBox = UICreatShortcut.creatAndAdd("boguAdventure.view.hpBox",this);
         this._openCountBg = UICreatShortcut.creatAndAdd("boguAdventure.stateView.openCountBg",this);
         this._openCountText = UICreatShortcut.creatAndAdd("boguAdventure.view.openCountText",this);
         this._limitResetText = UICreatShortcut.creatTextAndAdd("boguAdventure.view.limitResetText",LanguageMgr.GetTranslation("boguAdventure.view.limitRevive"),this);
         this._resetNumText = UICreatShortcut.creatAndAdd("boguAdventure.view.openCountText",this);
         PositionUtils.setPos(this._resetNumText,"boguAdventure.view.resetNumPos");
      }
      
      public function updateView() : void
      {
         if(this._control.changeMouse)
         {
            this._mouseStyle.x = stage.mouseX - this._mouseStyle.width / 2;
            this._mouseStyle.y = stage.mouseY - this._mouseStyle.height / 2;
         }
         this._changeView.update();
      }
      
      private function __onAllEvent(e:BoguAdventureEvent) : void
      {
         switch(e.eventType)
         {
            case BoguAdventureEvent.WALK:
               this._changeView.boguWalk(e.data as Array);
               break;
            case BoguAdventureEvent.STOP:
               SocketManager.Instance.out.sendBoguAdventureWalkInfo(4,this._control.currentIndex);
               break;
            case BoguAdventureEvent.UPDATE_CELL:
               this.updateCell(e.data["index"],e.data["type"],e.data["result"],true);
               break;
            case BoguAdventureEvent.ACTION_COMPLETE:
               this.playActionComplete(e.data);
               break;
            case BoguAdventureEvent.CHANGE_HP:
               this.updateHp();
               break;
            case BoguAdventureEvent.UPDATE_MAP:
               this.updateMap();
               break;
            case BoguAdventureEvent.UPDATE_RESET:
               this.updateReset();
         }
      }
      
      private function updateCell(index:int, type:int, result:int, playAction:Boolean = false) : void
      {
         var cell:BoguAdventureCell = this._map.getCellByIndex(index);
         cell.info.result = result;
         switch(type)
         {
            case 1:
               cell.info.state = BoguAdventureCellInfo.SIGN;
               this._changeView.placeGoods(BoguAdventureChangeView.SIGN,cell.info.index,this._map.getCellPosIndex(cell.info.index,this._control.signFocus));
               break;
            case 2:
               cell.info.state = BoguAdventureCellInfo.NOT_OPEN;
               this._changeView.celarGoods(cell.info.index);
               break;
            case 3:
               if(cell.info.state != BoguAdventureCellInfo.OPEN)
               {
                  cell.info.state = BoguAdventureCellInfo.OPEN;
                  this._changeView.celarGoods(index);
                  this._map.playFineMineAction(index);
               }
               break;
            case 4:
               this.openCell(cell,playAction);
         }
      }
      
      private function openCell(cell:BoguAdventureCell, playAction:Boolean) : void
      {
         if(cell.info.result == BoguAdventureCellInfo.MINE)
         {
            this._changeView.placeGoods(BoguAdventureChangeView.MINE,cell.info.index,this._map.getCellPosIndex(cell.info.index,this._control.mineFocus));
            if(playAction)
            {
               this._changeView.playExplodAciton();
            }
         }
         else if(playAction)
         {
            this._changeView.playWarnAction(cell.info.aroundMineCount,this._map.getCellPosIndex(cell.info.index,this._control.mineNumFocus));
            if(cell.info.state != BoguAdventureCellInfo.OPEN && cell.info.result != BoguAdventureCellInfo.SPACE)
            {
               this._changeView.playAwardAction(cell.info.result);
               cell.changeCellBg();
            }
            else
            {
               this._map.mouseClickOpen();
               this._control.isMove = false;
            }
         }
         else
         {
            cell.changeCellBg();
         }
         cell.info.state = BoguAdventureCellInfo.OPEN;
         cell.open();
         this.updateOpenCount();
      }
      
      private function updateMap() : void
      {
         var info:BoguAdventureCellInfo = null;
         var type:int = 0;
         this._changeView.clearChangeView();
         this._changeView.clearWarnAction();
         if(this._control.model.mapInfoList != null)
         {
            for each(info in this._control.model.mapInfoList)
            {
               this._map.getCellByIndex(info.index).info = info;
               type = 0;
               if(info.state == BoguAdventureCellInfo.OPEN)
               {
                  type = 4;
               }
               else if(info.state == BoguAdventureCellInfo.SIGN)
               {
                  type = 1;
               }
               if(type != 0)
               {
                  this.updateCell(info.index,type,info.result);
               }
            }
         }
         this._changeView.resetBogu(this._map.getCellPosIndex(this._control.currentIndex,this._control.bogu.focusPos));
         if(Boolean(this._control.currentIndex) && this._map.getCellByIndex(this._control.currentIndex).info.result != BoguAdventureCellInfo.MINE)
         {
            this._changeView.playWarnAction(this._map.getCellByIndex(this._control.currentIndex).info.aroundMineCount,this._map.getCellPosIndex(this._control.currentIndex,this._control.mineNumFocus));
         }
         this.updateHp();
         this._changeView.boguState(this._control.hp > 0);
         this.updateOpenCount();
         this._map.mouseClickOpen();
         this.updateReset();
         this._control.isMove = false;
      }
      
      private function updateReset() : void
      {
         this._resetBtn.visible = !this._control.model.isFreeReset;
         this._limitResetText.visible = !this._control.model.isFreeReset;
         this._resetNumText.visible = !this._control.model.isFreeReset;
         this._freeResetBtn.visible = this._control.model.isFreeReset;
         this._resetNumText.text = this._control.model.resetCount.toString();
      }
      
      private function __onReviveClick(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("boguAdventure.view.reviveText",this._control.model.revivePrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onReviveAffirmRevive);
      }
      
      private function __onReviveAffirmRevive(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         e.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onReviveAffirmRevive);
         ObjectUtils.disposeObject(e.currentTarget);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(this._control.model.isAcquireAward1 && this._control.model.isAcquireAward2 && this._control.model.isAcquireAward3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.acquireAward"));
               return;
            }
            if(PlayerManager.Instance.Self.Money < this._control.model.revivePrice)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendBoguAdventureUpdateGame(1);
         }
      }
      
      private function __onAwardClick(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.clearEffect();
         var frame:BoguAdventureAwardFrame = ComponentFactory.Instance.creatCustomObject("boguAdventure.awardFrame");
         frame.control = this._control;
         frame.show();
      }
      
      private function __onResetClick(e:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.playButtonSound();
         if(this._control.currentIndex == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.notReset"));
            return;
         }
         if(this._control.model.resetCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.resetCountOver"));
            return;
         }
         if(this._control.isMove)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.move"));
            return;
         }
         if(this._control.checkGetAward())
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("boguAdventure.view.resetText"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onResetTip);
         }
         else if(this._control.model.isFreeReset)
         {
            SocketManager.Instance.out.sendBoguAdventureUpdateGame(2);
         }
         else
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("boguAdventure.view.resetAffirmText",this._control.model.resetPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onResetAffirmRevive);
         }
      }
      
      private function __onResetTip(e:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.playButtonSound();
         e.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onResetTip);
         ObjectUtils.disposeObject(e.currentTarget);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this._control.model.isFreeReset)
            {
               SocketManager.Instance.out.sendBoguAdventureUpdateGame(2);
            }
            else
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("boguAdventure.view.resetAffirmText",this._control.model.resetPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onResetAffirmRevive);
            }
         }
      }
      
      private function __onResetAffirmRevive(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         e.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onResetAffirmRevive);
         ObjectUtils.disposeObject(e.currentTarget);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(PlayerManager.Instance.Self.Money < this._control.model.resetPrice)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if(this._control.model.resetCount <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.notRevive"));
               return;
            }
            SocketManager.Instance.out.sendBoguAdventureUpdateGame(2);
         }
      }
      
      private function __onFindMineClick(e:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.playButtonSound();
         if(!this._control.checkGameOver())
         {
            if(this._control.currentIndex == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.notStart"));
               return;
            }
            if(this._map.getCellByIndex(this._control.currentIndex).info.aroundMineCount <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.notFineMine"));
               return;
            }
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("boguAdventure.view.findMineText",this._control.model.findMinePrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onFindAffirmRevive);
         }
      }
      
      private function __onFindAffirmRevive(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         e.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onFindAffirmRevive);
         ObjectUtils.disposeObject(e.currentTarget);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(PlayerManager.Instance.Self.Money < this._control.model.findMinePrice)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendBoguAdventureWalkInfo(3);
         }
      }
      
      private function __onSignClick(e:MouseEvent) : void
      {
         if(!this._control.checkGameOver())
         {
            SoundManager.instance.playButtonSound();
            if(!this._control.changeMouse)
            {
               this.changeMouseStyle(true);
               e.stopImmediatePropagation();
               StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__onStageClick,true);
            }
         }
      }
      
      private function __onKeyDown(e:KeyboardEvent) : void
      {
         if(e.keyCode == KeyStroke.VK_F.getCode())
         {
            if(!this._control.checkGameOver())
            {
               SoundManager.instance.playButtonSound();
               if(!this._control.changeMouse)
               {
                  this.changeMouseStyle(true);
                  e.stopImmediatePropagation();
                  StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__onStageClick,true);
               }
               else
               {
                  this.changeMouseStyle(false);
                  StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick,true);
               }
            }
         }
      }
      
      private function __onStageClick(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick,true);
         if(this._control.changeMouse)
         {
            if(e.target is BoguAdventureCell)
            {
               this.signCell(e.target as BoguAdventureCell);
            }
            this.changeMouseStyle(false);
            e.stopImmediatePropagation();
         }
      }
      
      private function changeMouseStyle(value:Boolean) : void
      {
         if(this._control.changeMouse == value)
         {
            return;
         }
         this._control.changeMouse = value;
         if(this._control.changeMouse)
         {
            Mouse.hide();
         }
         else
         {
            Mouse.show();
         }
         this._mouseStyle.visible = this._control.changeMouse;
      }
      
      private function signCell(value:BoguAdventureCell) : void
      {
         var cell:BoguAdventureCell = value;
         if(this._control.currentIndex == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.notStart"));
            return;
         }
         if(cell.info.state == BoguAdventureCellInfo.SIGN)
         {
            SocketManager.Instance.out.sendBoguAdventureWalkInfo(2,cell.info.index);
            return;
         }
         if(cell.info.state == BoguAdventureCellInfo.OPEN)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.notSignOpenCell"));
            return;
         }
         SocketManager.Instance.out.sendBoguAdventureWalkInfo(1,cell.info.index);
      }
      
      private function updateHp() : void
      {
         var i:int = 0;
         var alert:BaseAlerFrame = null;
         ObjectUtils.disposeAllChildren(this._hpBox);
         if(this._control.hp > 0)
         {
            for(i = 0; i < this._control.hp; i++)
            {
               this._hpBox.addChild(ComponentFactory.Instance.creat("boguAdventure.stateView.hp"));
            }
         }
         if(this._reviveBtn.enable && Boolean(this._control.hp > 0))
         {
            this._changeView.boguState(true);
         }
         this._reviveBtn.enable = Boolean(this._control.hp <= 0);
         if(this._control.hp <= 0)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("boguAdventure.view.reviveText",this._control.model.revivePrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onReviveAffirmRevive);
         }
      }
      
      private function playActionComplete(data:Object) : void
      {
         var index:int = 0;
         var type:String = String(data["type"]);
         if(type == BoguAdventureActionType.ACTINO_EXPLODE)
         {
            this._changeView.boguState(this._control.hp > 0);
         }
         else if(type == BoguAdventureActionType.ACTION_FINT_MINE)
         {
            index = int(data["index"]);
            this._map.getCellByIndex(index).open();
            this._changeView.placeGoods(BoguAdventureChangeView.MINE,index,this._map.getCellPosIndex(index,this._control.mineFocus));
         }
         this._map.mouseClickOpen();
         this._control.isMove = false;
      }
      
      private function updateOpenCount() : void
      {
         this._openCountText.text = this._control.model.openCount.toString();
         if(this._control.checkGetAward())
         {
            this.createEffect();
         }
         else
         {
            this.clearEffect();
         }
      }
      
      private function createEffect() : void
      {
         if(Boolean(this._arardBtnEffect))
         {
            return;
         }
         var shineData:Object = new Object();
         shineData[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
         this._arardBtnEffect = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._awardBtn,shineData);
         this._arardBtnEffect.play();
      }
      
      private function clearEffect() : void
      {
         if(this._arardBtnEffect == null)
         {
            return;
         }
         this._arardBtnEffect.stop();
         ObjectUtils.disposeObject(this._arardBtnEffect);
         this._arardBtnEffect = null;
      }
      
      private function initEvent() : void
      {
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         this._reviveBtn.addEventListener(MouseEvent.CLICK,this.__onReviveClick);
         this._awardBtn.addEventListener(MouseEvent.CLICK,this.__onAwardClick);
         this._resetBtn.addEventListener(MouseEvent.CLICK,this.__onResetClick);
         this._freeResetBtn.addEventListener(MouseEvent.CLICK,this.__onResetClick);
         this._signBtn.addEventListener(MouseEvent.CLICK,this.__onSignClick);
         this._findMineBtn.addEventListener(MouseEvent.CLICK,this.__onFindMineClick);
         this._control.addEventListener(BoguAdventureEvent.EVENT,this.__onAllEvent);
      }
      
      private function removeEvent() : void
      {
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown);
         this._reviveBtn.removeEventListener(MouseEvent.CLICK,this.__onReviveClick);
         this._awardBtn.removeEventListener(MouseEvent.CLICK,this.__onAwardClick);
         this._resetBtn.removeEventListener(MouseEvent.CLICK,this.__onResetClick);
         this._freeResetBtn.removeEventListener(MouseEvent.CLICK,this.__onResetClick);
         this._signBtn.removeEventListener(MouseEvent.CLICK,this.__onSignClick);
         this._findMineBtn.removeEventListener(MouseEvent.CLICK,this.__onFindMineClick);
         this._control.removeEventListener(BoguAdventureEvent.EVENT,this.__onAllEvent);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._changeView);
         this._changeView = null;
         ObjectUtils.disposeObject(this._map);
         this._map = null;
         ObjectUtils.disposeObject(this._reviveBtn);
         this._reviveBtn = null;
         ObjectUtils.disposeObject(this._awardBtn);
         this._awardBtn = null;
         this.clearEffect();
         ObjectUtils.disposeObject(this._resetBtn);
         this._resetBtn = null;
         ObjectUtils.disposeObject(this._freeResetBtn);
         this._freeResetBtn = null;
         ObjectUtils.disposeObject(this._signBtn);
         this._signBtn = null;
         ObjectUtils.disposeObject(this._findMineBtn);
         this._findMineBtn = null;
         ObjectUtils.disposeObject(this._helpView);
         this._helpView = null;
         ObjectUtils.disposeObject(this._mouseStyle);
         this._mouseStyle = null;
         if(Boolean(this._hpBox))
         {
            ObjectUtils.disposeAllChildren(this._hpBox);
            ObjectUtils.disposeObject(this._hpBox);
         }
         this._hpBox = null;
         ObjectUtils.disposeObject(this._openCountBg);
         this._openCountBg = null;
         ObjectUtils.disposeObject(this._openCountText);
         this._openCountText = null;
         ObjectUtils.disposeObject(this._limitResetText);
         this._limitResetText = null;
         ObjectUtils.disposeObject(this._resetNumText);
         this._resetNumText = null;
         this._control = null;
         this.parent.removeChild(this);
      }
   }
}

