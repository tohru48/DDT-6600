package game.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import game.GameManager;
   import game.model.Living;
   
   public class DamageView extends Sprite
   {
      
      private var _viewDamageBtn:BaseButton;
      
      private var _infoSprite:Sprite;
      
      private var _bg:Bitmap;
      
      private var _title:FilterFrameText;
      
      private var _listTxt:FilterFrameText;
      
      private var _userNameVec:Vector.<FilterFrameText>;
      
      private var _damageNumVec:Vector.<FilterFrameText>;
      
      private var _openFlag:Boolean = false;
      
      public function DamageView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var userName:FilterFrameText = null;
         var damageNum:FilterFrameText = null;
         this._viewDamageBtn = ComponentFactory.Instance.creatComponentByStylename("game.view.damageView.viewDamageBtn");
         addChild(this._viewDamageBtn);
         this._infoSprite = new Sprite();
         addChild(this._infoSprite);
         PositionUtils.setPos(this._infoSprite,"asset.game.damageView.SpritePos");
         this._bg = ComponentFactory.Instance.creat("asset.game.damageView.bg");
         this._infoSprite.addChild(this._bg);
         this._title = ComponentFactory.Instance.creatComponentByStylename("game.view.damageView.titleTxt");
         this._title.text = LanguageMgr.GetTranslation("ddt.game.view.damageView.titleText");
         this._infoSprite.addChild(this._title);
         this._listTxt = ComponentFactory.Instance.creatComponentByStylename("game.view.damageView.listTxt");
         this._listTxt.text = LanguageMgr.GetTranslation("ddt.game.view.damageView.listText");
         this._infoSprite.addChild(this._listTxt);
         this._userNameVec = new Vector.<FilterFrameText>();
         this._damageNumVec = new Vector.<FilterFrameText>();
         for(var i:int = 0; i < 4; i++)
         {
            userName = ComponentFactory.Instance.creatComponentByStylename("game.view.damageView.userInfo");
            PositionUtils.setPos(userName,"game.view.damageView.userNamePos" + i);
            this._userNameVec.push(userName);
            this._infoSprite.addChild(userName);
            damageNum = ComponentFactory.Instance.creatComponentByStylename("game.view.damageView.userInfo");
            PositionUtils.setPos(damageNum,"game.view.damageView.damageNumPos" + i);
            this._damageNumVec.push(damageNum);
            this._infoSprite.addChild(damageNum);
         }
         this.updateView();
      }
      
      private function initEvent() : void
      {
         this._viewDamageBtn.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
      }
      
      public function updateView() : void
      {
         var living:Living = null;
         var numID:int = 0;
         this.clearTextInfo();
         for each(living in GameManager.Instance.Current.livings)
         {
            if(living.isPlayer())
            {
               this._userNameVec[numID].text = living.playerInfo.NickName;
               if(this._userNameVec[numID].text.length > 10)
               {
                  this._userNameVec[numID].text = living.playerInfo.NickName.substr(0,8) + "...";
               }
               this._damageNumVec[numID].text = living.damageNum.toString();
               living.damageNum = 0;
               numID++;
            }
         }
      }
      
      private function clearTextInfo() : void
      {
         for(var i:int = 0; i < this._userNameVec.length; i++)
         {
            this._userNameVec[i].text = "";
            this._damageNumVec[i].text = "";
         }
      }
      
      protected function __onMouseClick(event:MouseEvent) : void
      {
         if(this._openFlag)
         {
            TweenLite.to(this._infoSprite,0.3,{
               "x":0,
               "scaleX":1,
               "scaleY":1,
               "alpha":1
            });
         }
         else
         {
            TweenLite.to(this._infoSprite,0.5,{
               "x":this._viewDamageBtn.x + this._viewDamageBtn.width / 2,
               "scaleX":0,
               "scaleY":0,
               "alpha":0
            });
         }
         this._openFlag = !this._openFlag;
      }
      
      private function removeEvent() : void
      {
         this._viewDamageBtn.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._viewDamageBtn))
         {
            this._viewDamageBtn.dispose();
            this._viewDamageBtn = null;
         }
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._title))
         {
            this._title.dispose();
            this._title = null;
         }
         if(Boolean(this._listTxt))
         {
            this._listTxt.dispose();
            this._listTxt = null;
         }
         for(var i:int = 0; i < 4; i++)
         {
            this._userNameVec[i].dispose();
            this._userNameVec[i] = null;
         }
         this._userNameVec.length = 0;
         this._userNameVec = null;
         for(var j:int = 0; j < 4; j++)
         {
            this._damageNumVec[j].dispose();
            this._damageNumVec[j] = null;
         }
         this._damageNumVec.length = 0;
         this._damageNumVec = null;
      }
   }
}

