package hall.hallInfo.playerInfo
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class PlayerFighterPower extends Sprite
   {
      
      private var _sp:Component;
      
      private var _selfInfo:SelfInfo;
      
      private var _container:Sprite;
      
      private var _fightPowerImg:Bitmap;
      
      private var _powerNum:Sprite;
      
      public function PlayerFighterPower()
      {
         super();
         this._selfInfo = PlayerManager.Instance.Self;
         this.initView();
      }
      
      private function initView() : void
      {
         this._sp = new Component();
         this._sp.graphics.beginFill(0,0);
         this._sp.graphics.drawRect(0,0,242,15);
         this._sp.graphics.endFill();
         this._sp.width = this._sp.displayWidth;
         this._sp.height = this._sp.displayHeight;
         this._sp.tipStyle = "ddt.view.tips.OneLineTip";
         this._sp.tipDirctions = "7,3,6";
         this._sp.tipData = LanguageMgr.GetTranslation("hall.playerInfo.powerTipText",this._selfInfo.FightPower);
         addChild(this._sp);
         this._container = new Sprite();
         addChild(this._container);
         this._fightPowerImg = ComponentFactory.Instance.creat("asset.hall.fightPowerImg");
         this._container.addChild(this._fightPowerImg);
         this._powerNum = ImgNumConverter.instance.convertToImg(this._selfInfo.FightPower,"asset.hall.playerInfo.num",8);
         PositionUtils.setPos(this._powerNum,"hall.playerInfo.powNumPos");
         this._container.addChild(this._powerNum);
         this._container.x = (this.width - this._container.width) / 2;
      }
      
      public function update() : void
      {
         if(Boolean(this._powerNum))
         {
            ObjectUtils.disposeObject(this._powerNum);
            this._powerNum = null;
            this._powerNum = ImgNumConverter.instance.convertToImg(this._selfInfo.FightPower,"asset.hall.playerInfo.num",8);
            PositionUtils.setPos(this._powerNum,"hall.playerInfo.powNumPos");
            this._container.addChild(this._powerNum);
         }
         if(Boolean(this._container))
         {
            this._container.x = (this.width - this._container.width) / 2;
         }
         this._sp.tipData = LanguageMgr.GetTranslation("hall.playerInfo.powerTipText",this._selfInfo.FightPower);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

