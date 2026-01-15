package changeColor.view
{
   import baglocked.BaglockedManager;
   import changeColor.ChangeColorCellEvent;
   import changeColor.ChangeColorModel;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ChangeColorRightView extends Sprite implements Disposeable
   {
      
      private var _bag:ColorChangeBagListView;
      
      private var _bg:ScaleBitmapImage;
      
      private var _bg1:MutipleImage;
      
      private var _btnBg:ScaleBitmapImage;
      
      private var _text1Img:FilterFrameText;
      
      private var _textImg:FilterFrameText;
      
      private var _shineEffect:IEffect;
      
      private var _changeColorBtn:BaseButton;
      
      private var _model:ChangeColorModel;
      
      public function ChangeColorRightView()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         this.init();
      }
      
      public function dispose() : void
      {
         this._model.removeEventListener(ChangeColorCellEvent.SETCOLOR,this.__updateBtn);
         this._changeColorBtn.removeEventListener(MouseEvent.CLICK,this.__changeColor);
         ObjectUtils.disposeAllChildren(this);
         this._changeColorBtn = null;
         this._bag = null;
         this._model = null;
         EffectManager.Instance.removeEffect(this._shineEffect);
         this._shineEffect = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function set model(value:ChangeColorModel) : void
      {
         this._model = value;
         this.dataUpdate();
      }
      
      private function __alertChangeColor(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertChangeColor);
         SoundManager.instance.play("008");
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.BandMoney < ShopManager.Instance.getGiftShopItemByTemplateID(EquipType.COLORCARD).getItemPrice(1).bandDdtMoneyValue)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.noOrder"));
               return;
            }
            this.sendChangeColor();
         }
      }
      
      private function __changeColor(evt:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._model.place != -1)
         {
            this.sendChangeColor();
            this._model.place = -1;
         }
         else if(this.hasColorCard() != -1)
         {
            this._model.place = this.hasColorCard();
            this.sendChangeColor();
            this._model.place = -1;
         }
         else
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("tank.view.changeColor.lackCard",ShopManager.Instance.getGiftShopItemByTemplateID(EquipType.COLORCARD).getItemPrice(1).bandDdtMoneyValue),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__alertChangeColor);
         }
         this._changeColorBtn.enable = false;
      }
      
      private function __updateBtn(evt:Event) : void
      {
         if(!this._model.changed)
         {
            this._changeColorBtn.enable = false;
         }
         else
         {
            this._changeColorBtn.enable = true;
         }
      }
      
      private function dataUpdate() : void
      {
         this._model.addEventListener(ChangeColorCellEvent.SETCOLOR,this.__updateBtn);
         this._bag.setData(this._model.colorEditableBag);
      }
      
      private function hasColorCard() : int
      {
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.COLORCARD) > 0)
         {
            return PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.COLORCARD).Place;
         }
         return -1;
      }
      
      private function init() : void
      {
         var rec:Rectangle = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("changeColor.rightViewBg");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.rightViewBgRec");
         ObjectUtils.copyPropertyByRectangle(this._bg,rec);
         addChild(this._bg);
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("ColorBGAsset4");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.rightViewBgRec1");
         ObjectUtils.copyPropertyByRectangle(this._bg1,rec);
         addChild(this._bg1);
         this._text1Img = ComponentFactory.Instance.creatComponentByStylename("asset.changeColor.text1");
         this._text1Img.text = LanguageMgr.GetTranslation("tank.view.changeColor.text4");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.text1ImgRec");
         ObjectUtils.copyPropertyByRectangle(this._text1Img,rec);
         addChild(this._text1Img);
         this._textImg = ComponentFactory.Instance.creatComponentByStylename("asset.changeColor.text2");
         this._textImg.text = LanguageMgr.GetTranslation("tank.view.changeColor.text5");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.textImgRec");
         ObjectUtils.copyPropertyByRectangle(this._textImg,rec);
         addChild(this._textImg);
         this._bag = new ColorChangeBagListView();
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.bagListViewRec");
         ObjectUtils.copyPropertyByRectangle(this._bag,rec);
         addChild(this._bag);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("changeColor.changeColorBtn.bg");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.buttonBgRec");
         ObjectUtils.copyPropertyByRectangle(this._btnBg,rec);
         addChild(this._btnBg);
         this._changeColorBtn = ComponentFactory.Instance.creatComponentByStylename("changeColor.changeColorBtn");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.changeColorBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._changeColorBtn,rec);
         this._changeColorBtn.enable = false;
         addChild(this._changeColorBtn);
         this._changeColorBtn.addEventListener(MouseEvent.CLICK,this.__changeColor);
      }
      
      private function __addToStage(event:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         var rec:Rectangle = ComponentFactory.Instance.creatCustomObject("changeColor.textImgGlowRec");
         this._shineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this,"asset.changeColor.shine",rec);
         this._shineEffect.stop();
      }
      
      private function sendChangeColor() : void
      {
         var cardBagType:int = BagInfo.PROPBAG;
         var cardPlace:int = this._model.place;
         var itemBagType:int = this._model.currentItem.BagType;
         var itemPlace:int = this._model.currentItem.Place;
         var color:String = this._model.currentItem.Color;
         var skin:String = this._model.currentItem.Skin;
         var templateID:int = EquipType.COLORCARD;
         this._model.initColor = color;
         this._model.initSkinColor = skin;
         SocketManager.Instance.out.sendChangeColor(cardBagType,cardPlace,itemBagType,itemPlace,color,skin,templateID);
         this._model.savaItemInfo();
      }
      
      public function get bag() : ColorChangeBagListView
      {
         return this._bag;
      }
   }
}

