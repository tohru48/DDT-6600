package campbattle.view
{
   import campbattle.CampBattleManager;
   import campbattle.event.MapEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.StaticFormula;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HeadInfoView extends Sprite
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      private var _backPic:Bitmap;
      
      private var _blood:Bitmap;
      
      private var _info:PlayerInfo;
      
      private var _character:ShowCharacter;
      
      private var _nameTxt:FilterFrameText;
      
      private var _bloodTxt:FilterFrameText;
      
      private var _teamTxt:FilterFrameText;
      
      private var _myScoreTxt:FilterFrameText;
      
      private var _currtAct:FilterFrameText;
      
      private var _capList:Array = ["",LanguageMgr.GetTranslation("ddt.campBattle.qinglong"),LanguageMgr.GetTranslation("ddt.campBattle.baihu"),LanguageMgr.GetTranslation("ddt.campBattle.zhuque"),LanguageMgr.GetTranslation("ddt.campBattle.xuanwu")];
      
      private var _figure:Bitmap;
      
      private var _directrion:String = "left";
      
      public function HeadInfoView(info:PlayerInfo)
      {
         super();
         this._info = info;
         this.initView();
      }
      
      private function initView() : void
      {
         this._backPic = ComponentFactory.Instance.creat("camp.campBattle.humanTitle");
         addChild(this._backPic);
         this._blood = ComponentFactory.Instance.creat("camp.campBattle.humanred");
         addChild(this._blood);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.headName");
         this._nameTxt.text = this._info.NickName;
         addChild(this._nameTxt);
         var max:int = StaticFormula.getMaxHp(this._info);
         this._bloodTxt = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.headBlood");
         this._bloodTxt.text = max + "/" + max;
         addChild(this._bloodTxt);
         this._teamTxt = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.headTeamInfo");
         this._teamTxt.text = this._capList[CampBattleManager.instance.model.myTeam];
         addChild(this._teamTxt);
         this._myScoreTxt = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.headSocre");
         this._myScoreTxt.text = CampBattleManager.instance.model.myScore.toString();
         addChild(this._myScoreTxt);
         this._currtAct = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.headAct");
         this._currtAct.text = CampBattleManager.instance.model.monsterCount.toString();
         addChild(this._currtAct);
         this._character = CharactoryFactory.createCharacter(this._info,"show") as ShowCharacter;
         this._character.showGun = false;
         this._character.setShowLight(false,null);
         this._character.stopAnimation();
         this._character.show(true,1);
         this._character.addEventListener(Event.COMPLETE,this.characterComplete);
         CampBattleManager.instance.addEventListener(MapEvent.PVE_COUNT,this.pevCountHander);
      }
      
      private function characterComplete(evt:Event) : void
      {
         var maskSp:MovieClip = null;
         if(this._figure && this._figure.parent && Boolean(this._figure.bitmapData))
         {
            this._figure.parent.removeChild(this._figure);
            this._figure.bitmapData.dispose();
            this._figure = null;
         }
         if(!this._character.info.getShowSuits())
         {
            this._figure = new Bitmap(new BitmapData(200,150));
            this._figure.bitmapData.copyPixels(this._character.characterBitmapdata,new Rectangle(0,60,200,150),new Point(0,0));
            this._figure.scaleX = 0.45 * (this._directrion == LEFT ? 1 : -1);
            this._figure.scaleY = 0.45;
            this._figure.x = this._directrion == LEFT ? 0 : 82;
            this._figure.y = 12;
         }
         else
         {
            this._figure = new Bitmap(new BitmapData(200,200));
            this._figure.bitmapData.copyPixels(this._character.characterBitmapdata,new Rectangle(0,10,200,200),new Point(0,0));
            this._figure.scaleX = 0.35 * (this._directrion == LEFT ? 1 : -1);
            this._figure.scaleY = 0.35;
            this._figure.x = this._directrion == LEFT ? 18 : 73;
            this._figure.y = 12;
            maskSp = ComponentFactory.Instance.creat("camp.battle.headmask");
            maskSp.x = 49;
            maskSp.y = 50;
            addChild(maskSp);
            this._figure.mask = maskSp;
         }
         addChild(this._figure);
      }
      
      private function pevCountHander(e:MapEvent) : void
      {
         this._currtAct.text = CampBattleManager.instance.model.monsterCount.toString();
      }
      
      public function updateScore(score:int) : void
      {
         this._myScoreTxt.text = score.toString();
      }
      
      public function dispose() : void
      {
         this._character.removeEventListener(Event.COMPLETE,this.characterComplete);
         CampBattleManager.instance.removeEventListener(MapEvent.PVE_COUNT,this.pevCountHander);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

