package game.view.experience
{
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.filters.GlowFilter;
   import game.GameManager;
   import game.model.Player;
   
   public class ExpLeftView extends Sprite implements Disposeable
   {
      
      private var _bigCharacter:Bitmap;
      
      private var _characterLight:MovieClip;
      
      private var _lightBg:Bitmap;
      
      private var _title:Bitmap;
      
      private var _bodyBg:Bitmap;
      
      private var _tabName:Bitmap;
      
      private var _tabExp:Bitmap;
      
      private var _tabExploit:Bitmap;
      
      private var _itemList:Vector.<ExpFriendItem>;
      
      private var _playersList:Vector.<Player>;
      
      private var _glowFilter:GlowFilter;
      
      private var _blurFilter:BlurFilter;
      
      public function ExpLeftView()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._itemList = new Vector.<ExpFriendItem>();
         this._glowFilter = new GlowFilter(16750848,1,3,3,1);
         this._blurFilter = new BlurFilter(5,5);
         this._playersList = GameManager.Instance.Current.allias;
         this._title = ComponentFactory.Instance.creatBitmap("asset.experience.friendViewTitleBg");
         this._bodyBg = ComponentFactory.Instance.creatBitmap("asset.experience.friendViewBodyBg");
         this._tabName = ComponentFactory.Instance.creatBitmap("asset.experience.tabName");
         this._tabExp = ComponentFactory.Instance.creatBitmap("asset.experience.tabExp");
         this._tabExploit = ComponentFactory.Instance.creatBitmap("asset.experience.tabExploit");
         this._characterLight = ComponentFactory.Instance.creat("asset.experience.characterLight");
         this._lightBg = ComponentFactory.Instance.creatBitmap("asset.experience.characterLightBg");
         if(GameManager.Instance.Current.selfGamePlayer.isWin)
         {
            this._bigCharacter = new Bitmap(GameManager.Instance.Current.selfGamePlayer.character.winCharater.clone());
            PositionUtils.setPos(this._bigCharacter,"experience.LeftViewCharacterWinPos");
         }
         else
         {
            this._bigCharacter = new Bitmap(GameManager.Instance.Current.selfGamePlayer.character.charaterWithoutWeapon.clone());
            PositionUtils.setPos(this._bigCharacter,"experience.LeftViewCharacterLosePos");
         }
         this._bigCharacter.smoothing = true;
         this._bigCharacter.scaleX = -1.44;
         this._bigCharacter.scaleY = 1.44;
         PositionUtils.setPos(this._characterLight,"experience.LeftViewCharacterLightPos");
         addChild(this._lightBg);
         addChild(this._characterLight);
         addChild(this._bigCharacter);
         addChild(this._title);
         addChild(this._bodyBg);
         addChild(this._tabName);
         addChild(this._tabExp);
         addChild(this._tabExploit);
         for(var i:int = 0; i < this._playersList.length; i++)
         {
            this._itemList.push(new ExpFriendItem(this._playersList[i]));
            PositionUtils.setPos(this._itemList[i],"experience.FriendItemPos_" + String(i + 1));
            addChild(this._itemList[i]);
         }
         this.initEffect();
      }
      
      private function initEffect() : void
      {
         TweenMax.to(this._glowFilter,0.8,{
            "startAt":{"color":16750848},
            "color":16737792,
            "yoyo":true,
            "repeat":-1,
            "onUpdate":this.updateFilter
         });
         TweenMax.to(this._blurFilter,0.8,{
            "startAt":{
               "blurX":5,
               "blurY":5
            },
            "blurX":2,
            "blurY":2,
            "yoyo":true,
            "repeat":-1
         });
         TweenMax.to(this._characterLight,0.8,{
            "startAt":{"alpha":0},
            "alpha":0.6,
            "yoyo":true,
            "repeat":-1
         });
      }
      
      private function updateFilter() : void
      {
         this._characterLight.filters = [this._glowFilter,this._blurFilter];
      }
      
      public function dispose() : void
      {
         TweenMax.killTweensOf(this._glowFilter);
         if(Boolean(this._characterLight) && Boolean(this._characterLight.parent))
         {
            this._characterLight.parent.removeChild(this._characterLight);
            this._characterLight = null;
         }
         if(Boolean(this._bigCharacter) && Boolean(this._bigCharacter.parent))
         {
            this._bigCharacter.parent.removeChild(this._bigCharacter);
            this._bigCharacter = null;
         }
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
            this._title = null;
         }
         if(Boolean(this._bodyBg))
         {
            ObjectUtils.disposeObject(this._bodyBg);
            this._bodyBg = null;
         }
         if(Boolean(this._tabName))
         {
            ObjectUtils.disposeObject(this._tabName);
            this._tabName = null;
         }
         if(Boolean(this._tabExp))
         {
            ObjectUtils.disposeObject(this._tabExp);
            this._tabExp = null;
         }
         if(Boolean(this._tabExploit))
         {
            ObjectUtils.disposeObject(this._tabExploit);
            this._tabExploit = null;
         }
         ObjectUtils.disposeObject(this._lightBg);
         this._lightBg = null;
         for(var i:int = 0; i < this._itemList.length; i++)
         {
            this._itemList[i].dispose();
            this._itemList[i] = null;
         }
         this._blurFilter = null;
         this._glowFilter = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

