package room.transnational
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import game.GameManager;
   import vip.VipController;
   
   public class TransnationalLeftView extends Sprite
   {
      
      private static var LeftView:TransnationalLeftView;
      
      private var _bg:Bitmap;
      
      private var _characterInfo:SelfInfo;
      
      private var _character:ICharacter;
      
      private var _nameText:FilterFrameText;
      
      private var _vipText:GradientText;
      
      private var _cellWea:TransnationalEquitmentCell;
      
      private var _cellAux:TransnationalEquitmentCell;
      
      private var _cellPet:TransnationalEquitmentCell;
      
      private var _integralCurrent:FilterFrameText;
      
      private var _dailyintegral:FilterFrameText;
      
      private var _ScoresShopBtn:BaseButton;
      
      private var _helpBtn:BaseButton;
      
      private var _levelIcon:LevelIcon;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _awardListView:TransnationalAwardListView;
      
      private var _weaHisID:int;
      
      private var _auxHisID:int;
      
      private var _petHisID:int;
      
      private var _lever:int;
      
      private var _ScoreDaily:int;
      
      private var _ScoreTotal:int;
      
      public function TransnationalLeftView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.TransnationalLeftView.BG");
         addChild(this._bg);
         this._characterInfo = new SelfInfo();
         ObjectUtils.copyProperties(this._characterInfo,PlayerManager.Instance.Self);
         this._characterInfo.setHatHide(false);
         this._characterInfo.setSuiteHide(false);
         this._character = CharactoryFactory.createCharacter(this._characterInfo,"room");
         this._character.showGun = true;
         this._character.show();
         this._character.setShowLight(true);
         this._character.scaleX = -1.2;
         this._character.scaleY = 1.2;
         PositionUtils.setPos(this._character,"asset.ddtroom.transnationalCharacter");
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("room.view.TransnationalLeftView.nickNameText");
         this._nameText.text = this._characterInfo.NickName;
         addChild(this._nameText);
         if(this._characterInfo.IsVIP)
         {
            this._vipText = VipController.instance.getVipNameTxt(104,this._characterInfo.typeVIP);
            this._vipText.text = this._characterInfo.NickName;
            this._vipText.x = this._nameText.x;
            this._vipText.y = this._nameText.y;
            this._vipText.textSize = 16;
            addChild(this._vipText);
         }
         PositionUtils.adaptNameStyle(this._characterInfo,this._nameText,this._vipText);
         this._integralCurrent = ComponentFactory.Instance.creatComponentByStylename("room.view.TransnationalLeftView.integralCurrent");
         this._dailyintegral = ComponentFactory.Instance.creatComponentByStylename("room.view.TransnationalLeftView.dailyintegral");
         this._integralCurrent.text = "0";
         this._dailyintegral.text = "0/" + TransnationalFightManager.SCORESDAILETOTAL;
         this._ScoresShopBtn = ComponentFactory.Instance.creatComponentByStylename("room.view.TransnationalLeftView.ScoresShopBtn");
         addChild(this._integralCurrent);
         addChild(this._dailyintegral);
         addChild(this._ScoresShopBtn);
         this.updataIcon();
         this.initCell();
      }
      
      public function updataplayer($style:String, $mainWeaID:int, $secWeaID:int, $petID:int, $lever:int) : void
      {
         var weaitemInfo:InventoryItemInfo = null;
         var secweapitemInfo:InventoryItemInfo = null;
         this._characterInfo.Style = $style;
         var arm:String = $style.split(",")[6].split("|")[0];
         this._characterInfo.WeaponID = int(arm);
         this._characterInfo.setHatHide(false);
         this._characterInfo.wingHide = false;
         this._characterInfo.Nimbus = 0;
         if($mainWeaID != this._weaHisID)
         {
            this._weaHisID = $mainWeaID;
            weaitemInfo = new InventoryItemInfo();
            ObjectUtils.copyProperties(weaitemInfo,ItemManager.Instance.getTemplateById(this._weaHisID));
            weaitemInfo.StrengthenLevel = TransnationalFightManager.TRANSNATIONAL_SECWEAPONLEVEL;
            weaitemInfo.CanCompose = false;
            weaitemInfo.CanStrengthen = false;
            weaitemInfo.BindType = 4;
            this._cellWea.Cellinfo = weaitemInfo as ItemTemplateInfo;
         }
         if($secWeaID != this._auxHisID)
         {
            this._auxHisID = $secWeaID;
            secweapitemInfo = new InventoryItemInfo();
            ObjectUtils.copyProperties(secweapitemInfo,ItemManager.Instance.getTemplateById(this._auxHisID));
            if(this._auxHisID != EquipType.WishKingBlessing)
            {
               secweapitemInfo.StrengthenLevel = TransnationalFightManager.TRANSNATIONAL_SECWEAPONLEVEL;
            }
            secweapitemInfo.CanCompose = false;
            secweapitemInfo.CanStrengthen = false;
            secweapitemInfo.BindType = 4;
            this._cellAux.Cellinfo = secweapitemInfo as ItemTemplateInfo;
         }
         if($petID != this._petHisID)
         {
            this._petHisID = $petID;
            this._cellPet.Cellinfo = PetInfoManager.getPetByTemplateID($petID);
         }
         if($lever != this._characterInfo.Grade)
         {
            this._characterInfo.Grade = $lever;
            this.updataIcon();
         }
         addChildAt(this._character as DisplayObject,1);
      }
      
      private function updataIcon() : void
      {
         var team:int = 0;
         if(Boolean(this._characterInfo))
         {
            if(this._levelIcon == null)
            {
               this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.room.transnational.levelIcon");
               if(this._characterInfo.IsVIP)
               {
                  this._levelIcon.x += 1;
               }
            }
            team = 1;
            if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               team = GameManager.Instance.Current.findLivingByPlayerID(this._characterInfo.ID,this._characterInfo.ZoneID) == null ? -1 : GameManager.Instance.Current.findLivingByPlayerID(this._characterInfo.ID,this._characterInfo.ZoneID).team;
            }
            this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
            this._levelIcon.setInfo(this._characterInfo.Grade,this._characterInfo.Repute,this._characterInfo.WinCount,this._characterInfo.TotalCount,this._characterInfo.FightPower,this._characterInfo.Offer,true,false,team);
            addChild(this._levelIcon);
            if(this._characterInfo.ID == PlayerManager.Instance.Self.ID || this._characterInfo.IsVIP)
            {
               if(this._vipIcon == null)
               {
                  this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.room.transnational.VipIcon");
               }
               this._vipIcon.setInfo(this._characterInfo);
               this._vipIcon.setSize(VipLevelIcon.SIZE_SMALL);
               if(!this._characterInfo.IsVIP)
               {
                  this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               }
               else
               {
                  this._vipIcon.filters = null;
               }
            }
            else if(Boolean(this._vipIcon))
            {
               this._vipIcon.dispose();
               this._vipIcon = null;
            }
         }
         else if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
      }
      
      public function updata() : void
      {
         this._integralCurrent.text = TransnationalFightManager.Instance.currentScores.toString();
         this._dailyintegral.text = TransnationalFightManager.Instance.dailyScores.toString() + "/" + TransnationalFightManager.SCORESDAILETOTAL;
         if(Boolean(this._awardListView))
         {
            this._awardListView.Scores = TransnationalFightManager.Instance.currentScores;
         }
      }
      
      private function initCell() : void
      {
         this._cellWea = CellFactory.instance.createTransnationalEquipmentCell();
         this._cellAux = CellFactory.instance.createTransnationalEquipmentCell();
         this._cellPet = CellFactory.instance.createTransnationalEquipmentCell();
         PositionUtils.setPos(this._cellWea,"asset.ddtroom.transnationalcellWeapon");
         PositionUtils.setPos(this._cellAux,"asset.ddtroom.transnationalcellAux");
         PositionUtils.setPos(this._cellPet,"asset.ddtroom.transnationalcellPet");
         addChild(this._cellWea);
         addChild(this._cellAux);
         addChild(this._cellPet);
      }
      
      private function initEvent() : void
      {
         this._ScoresShopBtn.addEventListener(MouseEvent.CLICK,this.__toScoresShop);
      }
      
      public function setScoeresShopBtnEnable(value:Boolean) : void
      {
         this._ScoresShopBtn.enable = value;
      }
      
      private function __toScoresShop(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._awardListView == null)
         {
            this._awardListView = ComponentFactory.Instance.creat("room.transnational.TransnationalAwardListView");
            this._awardListView.titleText = LanguageMgr.GetTranslation("Transnational.ScoreShop.Title");
            this._awardListView.addEventListener(FrameEvent.RESPONSE,this.__closeFrame);
            this._awardListView.Scores = TransnationalFightManager.Instance.currentScores;
         }
         LayerManager.Instance.addToLayer(this._awardListView,LayerManager.GAME_TOP_LAYER,true);
      }
      
      private function __closeFrame(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this._awardListView.parent.removeChild(this._awardListView);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._awardListView))
         {
            this._awardListView.dispose();
            this._awardListView = null;
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._characterInfo);
         this._characterInfo = null;
         ObjectUtils.disposeObject(this._characterInfo);
         this._characterInfo = null;
         ObjectUtils.disposeObject(this._nameText);
         this._nameText = null;
         if(Boolean(this._vipText))
         {
            ObjectUtils.disposeObject(this._vipText);
            this._vipText = null;
         }
         if(Boolean(this._cellWea))
         {
            this._cellWea.dispose();
            this._cellWea = null;
         }
         if(Boolean(this._cellAux))
         {
            this._cellAux.dispose();
            this._cellAux = null;
         }
         if(Boolean(this._cellPet))
         {
            this._cellPet.dispose();
            this._cellAux = null;
         }
         ObjectUtils.disposeObject(this._integralCurrent);
         this._integralCurrent = null;
         ObjectUtils.disposeObject(this._dailyintegral);
         this._dailyintegral = null;
         ObjectUtils.disposeObject(this._ScoresShopBtn);
         this._ScoresShopBtn = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         if(Boolean(this._vipIcon))
         {
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
         }
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

