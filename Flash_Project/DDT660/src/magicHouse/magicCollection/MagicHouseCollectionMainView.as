package magicHouse.magicCollection
{
   import bagAndInfo.bag.RichesButton;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import magicHouse.MagicHouseManager;
   
   public class MagicHouseCollectionMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _typeWeaponBtn:SimpleBitmapButton;
      
      private var _freeBtn:SimpleBitmapButton;
      
      private var _goldenBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _upgradeBtn:SimpleBitmapButton;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var _lianchoubichu:FilterFrameText;
      
      private var _promoteMagicAttack:FilterFrameText;
      
      private var _promoteMagicDefense:FilterFrameText;
      
      private var _promoteCritDamage:FilterFrameText;
      
      private var _valueMagicAttack:FilterFrameText;
      
      private var _valueMagicDefense:FilterFrameText;
      
      private var _valueCritDamage:FilterFrameText;
      
      private var _juniorItem:MagicHouseCollectionItemView;
      
      private var _midItem:MagicHouseCollectionItemView;
      
      private var _seniorItem:MagicHouseCollectionItemView;
      
      private var _freeCell:Bitmap;
      
      private var _chargeCell:Bitmap;
      
      private var _freeCellBtn:RichesButton;
      
      private var _chargeCellBtn:RichesButton;
      
      private var _freeCountTxt:FilterFrameText;
      
      private var _chargeCounttxt:FilterFrameText;
      
      public function MagicHouseCollectionMainView()
      {
         super();
         MagicHouseManager.instance.selectEquipFromBag();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("magichouse.collectionviewbg");
         addChild(this._bg);
         this._typeWeaponBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.typeWeaponBtn");
         addChild(this._typeWeaponBtn);
         this._freeBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.freeBtn");
         addChild(this._freeBtn);
         this._goldenBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.goldenBtn");
         addChild(this._goldenBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.helpBtn");
         addChild(this._helpBtn);
         this._lianchoubichu = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.lianchoubichuTxt");
         this._lianchoubichu.text = LanguageMgr.GetTranslation("magichouse.collectionView.lianchoubichu");
         addChild(this._lianchoubichu);
         this._promoteMagicAttack = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.promoteTotleAbilityTxt");
         this._promoteMagicDefense = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.promoteTotleAbilityTxt");
         this._promoteCritDamage = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.promoteTotleAbilityTxt");
         this._promoteMagicAttack.text = LanguageMgr.GetTranslation("magichouse.collectionView.promoteMagicAttack");
         this._promoteMagicDefense.text = LanguageMgr.GetTranslation("magichouse.collectionView.promoteMagicDefense");
         this._promoteCritDamage.text = LanguageMgr.GetTranslation("magichouse.collectionView.promoteCritDamage");
         PositionUtils.setPos(this._promoteMagicAttack,"magicHouse.promoteMagicAttackPos");
         PositionUtils.setPos(this._promoteMagicDefense,"magicHouse.promoteMagicDefensePos");
         PositionUtils.setPos(this._promoteCritDamage,"magicHouse.promoteCritDamagePos");
         addChild(this._promoteMagicAttack);
         addChild(this._promoteMagicDefense);
         addChild(this._promoteCritDamage);
         this._valueMagicAttack = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.valueTotleAbilityTxt");
         this._valueMagicDefense = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.valueTotleAbilityTxt");
         this._valueCritDamage = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.valueTotleAbilityTxt");
         PositionUtils.setPos(this._valueMagicAttack,"magicHouse.valueMagicAttackPos");
         PositionUtils.setPos(this._valueMagicDefense,"magicHouse.valueMagicDefensePos");
         PositionUtils.setPos(this._valueCritDamage,"magicHouse.valueCritDamagePos");
         addChild(this._valueMagicAttack);
         addChild(this._valueMagicDefense);
         addChild(this._valueCritDamage);
         this._juniorItem = new MagicHouseCollectionItemView(1);
         this._midItem = new MagicHouseCollectionItemView(2);
         this._seniorItem = new MagicHouseCollectionItemView(3);
         addChild(this._juniorItem);
         addChild(this._midItem);
         addChild(this._seniorItem);
         PositionUtils.setPos(this._midItem,"magicHouse.collection.miditemPos");
         PositionUtils.setPos(this._seniorItem,"magicHouse.collection.senioritemPos");
         this._freeCell = ComponentFactory.Instance.creatBitmap("magichouse.collection.freeCell");
         addChild(this._freeCell);
         this._freeCellBtn = ComponentFactory.Instance.creatCustomObject("magichouse.collectionView.freeBtn");
         this._freeCellBtn.tipData = LanguageMgr.GetTranslation("magichouse.collectionView.freeGetTips");
         addChild(this._freeCellBtn);
         this._freeCountTxt = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.freeCountTxt");
         this._freeCountTxt.text = "(" + (MagicHouseManager.FREEBOX_MAXCOUNT - MagicHouseManager.instance.freeGetCount) + ")";
         addChild(this._freeCountTxt);
         this._chargeCounttxt = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.chargeCountTxt");
         this._chargeCounttxt.text = "(" + (MagicHouseManager.CHARGEBOX_MAXCOUNT - MagicHouseManager.instance.chargeGetCount) + ")";
         addChild(this._chargeCounttxt);
         if(MagicHouseManager.instance.checkGetFreeBoxTime())
         {
            this._freeCountTxt.text = "(" + (MagicHouseManager.FREEBOX_MAXCOUNT - 0) + ")";
         }
         if(MagicHouseManager.instance.chechGetChargeBoxTime())
         {
            this._chargeCounttxt.text = "(" + (MagicHouseManager.CHARGEBOX_MAXCOUNT - 0) + ")";
         }
         this._chargeCell = ComponentFactory.Instance.creatBitmap("magichouse.collection.chargeCell");
         addChild(this._chargeCell);
         this._chargeCellBtn = ComponentFactory.Instance.creatCustomObject("magichouse.collectionView.chargeBtn");
         this._chargeCellBtn.tipData = LanguageMgr.GetTranslation("magichouse.collectionView.chargeGetTips",MagicHouseManager.instance.boxNeedmoney);
         addChild(this._chargeCellBtn);
         this.setData();
      }
      
      private function setData() : void
      {
         var j:int = 0;
         var m:int = 0;
         var s:int = 0;
         var finalMagicAttack:int = 0;
         var finalMagicDefense:int = 0;
         var finalCritDamage:int = 0;
         var weapons:Array = MagicHouseManager.instance.activityWeapons;
         var juniorAttribute:Array = MagicHouseManager.instance.juniorAddAttribute;
         var juniorLv:int = MagicHouseManager.instance.magicJuniorLv;
         var minAttribute:Array = MagicHouseManager.instance.midAddAttribute;
         var midLv:int = MagicHouseManager.instance.magicMidLv;
         var seniorAttribute:Array = MagicHouseManager.instance.seniorAddAttribute;
         var seniorLv:int = MagicHouseManager.instance.magicSeniorLv;
         if(Boolean(weapons[0]) && Boolean(weapons[1]) && Boolean(weapons[2]))
         {
            for(j = 0; j <= juniorLv; j++)
            {
               finalMagicAttack += int(juniorAttribute[j].split(",")[0]);
               finalMagicDefense += int(juniorAttribute[j].split(",")[1]);
               finalCritDamage += int(juniorAttribute[j].split(",")[2]);
            }
         }
         if(Boolean(weapons[3]) && Boolean(weapons[4]) && Boolean(weapons[5]))
         {
            for(m = 0; m <= midLv; m++)
            {
               finalMagicAttack += int(minAttribute[m].split(",")[0]);
               finalMagicDefense += int(minAttribute[m].split(",")[1]);
               finalCritDamage += int(minAttribute[m].split(",")[2]);
            }
         }
         if(Boolean(weapons[6]) && Boolean(weapons[7]) && Boolean(weapons[8]))
         {
            for(s = 0; s <= seniorLv; s++)
            {
               finalMagicAttack += int(seniorAttribute[s].split(",")[0]);
               finalMagicDefense += int(seniorAttribute[s].split(",")[1]);
               finalCritDamage += int(seniorAttribute[s].split(",")[2]);
            }
         }
         this._valueMagicAttack.text = finalMagicAttack + "%";
         this._valueMagicDefense.text = finalMagicDefense + "%";
         this._valueCritDamage.text = finalCritDamage + "%";
         this._freeCountTxt.text = "(" + (MagicHouseManager.FREEBOX_MAXCOUNT - MagicHouseManager.instance.freeGetCount) + ")";
         this._chargeCounttxt.text = "(" + (MagicHouseManager.CHARGEBOX_MAXCOUNT - MagicHouseManager.instance.chargeGetCount) + ")";
         if(MagicHouseManager.instance.checkGetFreeBoxTime())
         {
            this._freeCountTxt.text = "(" + (MagicHouseManager.FREEBOX_MAXCOUNT - 0) + ")";
         }
         if(MagicHouseManager.instance.chechGetChargeBoxTime())
         {
            this._chargeCounttxt.text = "(" + (MagicHouseManager.CHARGEBOX_MAXCOUNT - 0) + ")";
         }
      }
      
      private function initEvent() : void
      {
         this._freeBtn.addEventListener(MouseEvent.CLICK,this.__freeGet);
         this._goldenBtn.addEventListener(MouseEvent.CLICK,this.__chargeGet);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpClick);
         MagicHouseManager.instance.addEventListener("MAGICHOUSE_UPDATA",this.__messageUpdate);
      }
      
      private function removeEvent() : void
      {
         this._freeBtn.removeEventListener(MouseEvent.CLICK,this.__freeGet);
         this._goldenBtn.removeEventListener(MouseEvent.CLICK,this.__chargeGet);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpClick);
         MagicHouseManager.instance.removeEventListener("MAGICHOUSE_UPDATA",this.__messageUpdate);
      }
      
      private function __helpClick(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("magichouse.mainview.frametitletext");
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("magichouse.collection.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      private function __messageUpdate(e:Event) : void
      {
         this.setData();
      }
      
      private function __freeGet(e:MouseEvent) : void
      {
         if(TimeManager.Instance.Now().getDate() != MagicHouseManager.instance.freeGetTime.getDate())
         {
            SocketManager.Instance.out.magicLibFreeGet(5);
         }
         else if(MagicHouseManager.FREEBOX_MAXCOUNT - MagicHouseManager.instance.freeGetCount > 0)
         {
            SocketManager.Instance.out.magicLibFreeGet(5);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionView.getBoxCountLess"));
         }
      }
      
      private function __chargeGet(e:MouseEvent) : void
      {
         if(TimeManager.Instance.Now().getDate() == MagicHouseManager.instance.chargeGetTime.getDate() && MagicHouseManager.CHARGEBOX_MAXCOUNT - MagicHouseManager.instance.chargeGetCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionView.getBoxCountLess"));
            return;
         }
         var frame:MagicHouseChargeBoxCountFrame = ComponentFactory.Instance.creatCustomObject("magicHouse.chargeBoxFrame");
         frame.addEventListener(FrameEvent.RESPONSE,this.__response);
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:MagicHouseChargeBoxCountFrame = e.currentTarget as MagicHouseChargeBoxCountFrame;
         switch(e.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               frame.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(TimeManager.Instance.Now().getDate() != MagicHouseManager.instance.chargeGetTime.getDate())
               {
                  SocketManager.Instance.out.magicLibChargeGet(frame.openCount);
               }
               else if(MagicHouseManager.CHARGEBOX_MAXCOUNT - MagicHouseManager.instance.chargeGetCount >= frame.openCount)
               {
                  SocketManager.Instance.out.magicLibChargeGet(frame.openCount);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionView.getBoxCountLess"));
               }
               frame.dispose();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._typeWeaponBtn))
         {
            this._typeWeaponBtn.dispose();
         }
         this._typeWeaponBtn = null;
         if(Boolean(this._freeBtn))
         {
            this._freeBtn.dispose();
         }
         this._freeBtn = null;
         if(Boolean(this._goldenBtn))
         {
            this._goldenBtn.dispose();
         }
         this._goldenBtn = null;
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.dispose();
         }
         this._helpBtn = null;
         if(Boolean(this._upgradeBtn))
         {
            this._upgradeBtn.dispose();
         }
         this._upgradeBtn = null;
         if(Boolean(this._helpFrame))
         {
            this._helpFrame.dispose();
         }
         this._helpFrame = null;
         if(Boolean(this._bgHelp))
         {
            this._bgHelp.dispose();
         }
         this._bgHelp = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
         if(Boolean(this._btnOk))
         {
            this._btnOk.dispose();
         }
         this._btnOk = null;
         if(Boolean(this._lianchoubichu))
         {
            this._lianchoubichu.dispose();
         }
         this._lianchoubichu = null;
         if(Boolean(this._promoteMagicAttack))
         {
            this._promoteMagicAttack.dispose();
         }
         this._promoteMagicAttack = null;
         if(Boolean(this._promoteMagicDefense))
         {
            this._promoteMagicDefense.dispose();
         }
         this._promoteMagicDefense = null;
         if(Boolean(this._promoteCritDamage))
         {
            this._promoteCritDamage.dispose();
         }
         this._promoteCritDamage = null;
         if(Boolean(this._valueMagicAttack))
         {
            this._valueMagicAttack.dispose();
         }
         this._valueMagicAttack = null;
         if(Boolean(this._valueMagicDefense))
         {
            this._valueMagicDefense.dispose();
         }
         this._valueMagicDefense = null;
         if(Boolean(this._valueCritDamage))
         {
            this._valueCritDamage.dispose();
         }
         this._valueCritDamage = null;
         if(Boolean(this._freeCell))
         {
            ObjectUtils.disposeObject(this._freeCell);
         }
         this._freeCell = null;
         if(Boolean(this._chargeCell))
         {
            ObjectUtils.disposeObject(this._chargeCell);
         }
         this._chargeCell = null;
         if(Boolean(this._freeCellBtn))
         {
            ObjectUtils.disposeObject(this._freeCellBtn);
         }
         this._freeCellBtn = null;
         if(Boolean(this._chargeCellBtn))
         {
            ObjectUtils.disposeObject(this._chargeCellBtn);
         }
         this._chargeCellBtn = null;
         if(Boolean(this._freeCountTxt))
         {
            ObjectUtils.disposeObject(this._freeCountTxt);
         }
         this._freeCountTxt = null;
         if(Boolean(this._chargeCounttxt))
         {
            ObjectUtils.disposeObject(this._chargeCounttxt);
         }
         this._chargeCounttxt = null;
         if(Boolean(this._juniorItem))
         {
            this._juniorItem.dispose();
         }
         this._juniorItem = null;
         if(Boolean(this._midItem))
         {
            this._midItem.dispose();
         }
         this._midItem = null;
         if(Boolean(this._seniorItem))
         {
            this._seniorItem.dispose();
         }
         this._seniorItem = null;
      }
   }
}

