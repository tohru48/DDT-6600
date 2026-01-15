package campbattle.view.rank
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   
   public class CampRankItem extends Component implements Disposeable
   {
      
      private var _scoreTxt:FilterFrameText;
      
      private var _manNumTxt:FilterFrameText;
      
      private var sp:Sprite;
      
      public function CampRankItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this.sp = new Sprite();
         this.sp.graphics.beginFill(0);
         this.sp.graphics.drawRect(0,0,180,28);
         this.sp.graphics.endFill();
         this.sp.alpha = 0;
         this.sp.x = -83;
         this.sp.y = -5;
         addChild(this.sp);
         tipStyle = "ddt.view.tips.OneLineTip";
         tipDirctions = "5,1,2";
         tipGapH = -50;
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.rankItemTxt");
         this._scoreTxt.text = "";
         this._scoreTxt.autoSize = TextFieldAutoSize.CENTER;
         addChild(this._scoreTxt);
         this._manNumTxt = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.rankItemTxt");
         this._manNumTxt.x = 63;
         this._manNumTxt.text = "";
         this._manNumTxt.autoSize = TextFieldAutoSize.CENTER;
         addChild(this._manNumTxt);
      }
      
      public function setItemTxt(obj:Object) : void
      {
         this._scoreTxt.text = obj.score;
         this._manNumTxt.text = obj.roles + "/15";
      }
      
      public function resetItemTxt() : void
      {
         this._scoreTxt.text = "";
         this._manNumTxt.text = "";
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._scoreTxt);
         ObjectUtils.disposeObject(this._manNumTxt);
         super.dispose();
      }
   }
}

