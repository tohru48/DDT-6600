package petsBag.petsAdvanced
{
   import baglocked.BaglockedManager;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import petsBag.data.PetsFormData;
   import petsBag.event.PetItemEvent;
   
   public class PetsFormPetsItem extends Component implements Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _pet:Sprite;
      
      private var _petsName:FilterFrameText;
      
      private var _followBtn:TextButton;
      
      private var _wakeBtn:TextButton;
      
      private var _callBackBtn:TextButton;
      
      private var _showBtnFlag:int;
      
      private var _info:PetsFormData;
      
      private var _itemId:int;
      
      public function PetsFormPetsItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsBg");
         addChild(this._bg);
         width = this._bg.width;
         height = this._bg.height;
         this._pet = new Sprite();
         PositionUtils.setPos(this._pet,"petsBag.form.petsPos");
         addChild(this._pet);
         this._petsName = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsNameTxt");
         addChild(this._petsName);
         this._followBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.followBtn");
         this._followBtn.text = LanguageMgr.GetTranslation("petsBag.form.petsFollowTxt");
         this._followBtn.visible = false;
         addChild(this._followBtn);
         this._wakeBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.followBtn");
         this._wakeBtn.text = LanguageMgr.GetTranslation("petsBag.form.petsWakeTxt");
         this._wakeBtn.visible = false;
         addChild(this._wakeBtn);
         this._callBackBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.callBackBtn");
         this._callBackBtn.text = LanguageMgr.GetTranslation("ddt.pets.unfight");
         this._callBackBtn.visible = false;
         addChild(this._callBackBtn);
      }
      
      private function initEvent() : void
      {
         this._followBtn.addEventListener(MouseEvent.CLICK,this.__onFollowClick);
         this._wakeBtn.addEventListener(MouseEvent.CLICK,this.__onWakeClick);
         this._callBackBtn.addEventListener(MouseEvent.CLICK,this.__onCallBackClick);
         addEventListener(MouseEvent.CLICK,this.__onMouseClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      public function setInfo(id:int, info:PetsFormData) : void
      {
         var tip:Object = null;
         this._itemId = id;
         this._info = info;
         if(Boolean(info))
         {
            tip = new Object();
            tip.title = info.Name;
            tip.isActive = info.State == 1;
            tip.state = info.State == 1 ? LanguageMgr.GetTranslation("petsBag.form.petsWakeTxt") : LanguageMgr.GetTranslation("petsBag.form.petsUnWakeTxt");
            tip.activeValue = info.Name + LanguageMgr.GetTranslation("petsBag.form.petsWakeCard");
            tip.propertyValue = LanguageMgr.GetTranslation("petsBag.form.petsListGuardTxt",info.HeathUp) + "\n" + LanguageMgr.GetTranslation("petsBag.form.petsabsorbHurtTxt",info.DamageReduce);
            tip.getValue = LanguageMgr.GetTranslation("petsBag.form.petsCrypt").toString().split(",")[id];
            tipData = tip;
            tipDirctions = "2,1";
            this.showBtn = info.ShowBtn;
            this._petsName.text = info.Name;
            this.addPetBitmap(info.Appearance);
         }
         else
         {
            this.showBtn = 0;
            ObjectUtils.disposeAllChildren(this._pet);
            this._petsName.text = "";
         }
      }
      
      public function addPetBitmap(path:String) : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.petsFormPath(path,this.showBtn == 3 ? 2 : 1),BaseLoader.BITMAP_LOADER);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         LoadResourceManager.Instance.startLoad(loader,true);
      }
      
      protected function __onComplete(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.loader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         loader.content.x = -loader.content.width / 2;
         loader.content.y = -loader.content.height;
         ObjectUtils.disposeAllChildren(this._pet);
         if(Boolean(this._pet))
         {
            this._pet.addChild(loader.content);
         }
      }
      
      protected function __onFollowClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         SocketManager.Instance.out.sendPetFollowOrCall(true,this._info.TemplateID);
         SocketManager.Instance.out.sendUpdatePets(true,PlayerManager.Instance.Self.ID,this._info.TemplateID);
      }
      
      protected function __onCallBackClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         SocketManager.Instance.out.sendPetFollowOrCall(false,this._info.TemplateID);
         SocketManager.Instance.out.sendUpdatePets(false,PlayerManager.Instance.Self.ID,0);
      }
      
      protected function __onWakeClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SocketManager.Instance.out.sendPetWake(this._info.TemplateID);
      }
      
      protected function __onMouseClick(event:MouseEvent) : void
      {
         if(this._bg.getFrame < 2)
         {
            SoundManager.instance.playButtonSound();
            dispatchEvent(new PetItemEvent(PetItemEvent.ITEM_CLICK,{"id":this._itemId}));
         }
      }
      
      protected function __onMouseOut(event:MouseEvent) : void
      {
         this.setBtnVisible(false);
      }
      
      protected function __onMouseOver(event:MouseEvent) : void
      {
         this.setBtnVisible(true);
      }
      
      private function setBtnVisible(flag:Boolean) : void
      {
         if(this._showBtnFlag == 1)
         {
            this._followBtn.visible = flag;
         }
         else if(this._showBtnFlag == 2)
         {
            this._callBackBtn.visible = flag;
         }
         else if(this._showBtnFlag == 3)
         {
            this._wakeBtn.visible = flag;
         }
      }
      
      public function set showBtn(value:int) : void
      {
         this._showBtnFlag = value;
         this.mouseChildren = this.mouseEnabled = true;
         this._bg.setFrame(1);
         if(value == 1)
         {
            this._callBackBtn.visible = false;
            this._wakeBtn.visible = false;
         }
         else if(value == 2)
         {
            this._followBtn.visible = false;
            this._wakeBtn.visible = false;
         }
         else if(value == 3)
         {
            this._followBtn.visible = false;
            this._callBackBtn.visible = false;
         }
         else
         {
            this._callBackBtn.visible = false;
            this._followBtn.visible = false;
            this._wakeBtn.visible = false;
            this._bg.setFrame(2);
            this.mouseChildren = this.mouseEnabled = false;
         }
      }
      
      public function get showBtn() : int
      {
         return this._showBtnFlag;
      }
      
      private function removeEvent() : void
      {
         this._followBtn.removeEventListener(MouseEvent.CLICK,this.__onFollowClick);
         this._wakeBtn.removeEventListener(MouseEvent.CLICK,this.__onWakeClick);
         this._callBackBtn.removeEventListener(MouseEvent.CLICK,this.__onCallBackClick);
         removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._petsName);
         this._petsName = null;
         ObjectUtils.disposeObject(this._followBtn);
         this._followBtn = null;
         ObjectUtils.disposeObject(this._wakeBtn);
         this._wakeBtn = null;
         ObjectUtils.disposeObject(this._callBackBtn);
         this._callBackBtn = null;
         if(Boolean(this._pet))
         {
            ObjectUtils.disposeAllChildren(this._pet);
            ObjectUtils.disposeObject(this._pet);
            this._pet = null;
         }
         this._info = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
      
      public function get info() : PetsFormData
      {
         return this._info;
      }
   }
}

