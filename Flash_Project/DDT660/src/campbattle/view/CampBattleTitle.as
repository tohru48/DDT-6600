package campbattle.view
{
   import campbattle.CampBattleManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   
   public class CampBattleTitle extends Sprite implements Disposeable
   {
      
      private var _backPic:Bitmap;
      
      private var _titleTxt1:FilterFrameText;
      
      private var _titleTxt2:FilterFrameText;
      
      private var _titleTxt3:FilterFrameText;
      
      private var _titleTxt4:FilterFrameText;
      
      public function CampBattleTitle()
      {
         super();
         x = 353;
         y = 35;
         this.initView();
      }
      
      private function initView() : void
      {
         this._backPic = ComponentFactory.Instance.creat("camp.battle.title.back");
         addChild(this._backPic);
         this._titleTxt1 = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.titleTxt7");
         this._titleTxt1.text = LanguageMgr.GetTranslation("ddt.campBattle.capturer");
         addChild(this._titleTxt1);
         this._titleTxt2 = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.titleTxt2");
         this._titleTxt2.autoSize = TextFieldAutoSize.NONE;
         this._titleTxt2.width = 100;
         this._titleTxt2.height = 20;
         if(Boolean(CampBattleManager.instance.model.captureName))
         {
            this._titleTxt2.text = CampBattleManager.instance.model.captureName;
         }
         else
         {
            this._titleTxt2.text = LanguageMgr.GetTranslation("ddt.campBattle.NOcapture");
         }
         addChild(this._titleTxt2);
         this._titleTxt3 = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.titleTxt3");
         this._titleTxt3.text = LanguageMgr.GetTranslation("ddt.campBattle.winCount");
         addChild(this._titleTxt3);
         this._titleTxt4 = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.titleTxt4");
         this._titleTxt4.text = CampBattleManager.instance.model.winCount.toString();
         addChild(this._titleTxt4);
      }
      
      public function setTitleTxt4(str:String) : void
      {
         if(Boolean(str))
         {
            this._titleTxt4.text = str;
         }
      }
      
      public function setTitleTxt2(str:String) : void
      {
         if(!str)
         {
            return;
         }
         this._titleTxt2.text = str;
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

