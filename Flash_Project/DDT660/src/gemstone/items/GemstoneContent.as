package gemstone.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import gemstone.GemstoneManager;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstoneTipVO;
   
   public class GemstoneContent extends Component
   {
      
      public static var _radius:int = 100;
      
      public var angle:int;
      
      public var curExp:int;
      
      public var curTotalExp:int;
      
      public var level:int;
      
      public var info:GemstListInfo;
      
      private var _setupAngle:int = 120;
      
      private var _initAngle:int = 30;
      
      private var _bg:MovieClip;
      
      private var _content:Bitmap;
      
      private var _upGradeMc:MovieClip;
      
      private var txt:FilterFrameText;
      
      public function GemstoneContent($i:int, $p:Point)
      {
         super();
         x = Math.round($p.x + Math.cos((this._setupAngle * $i + this._initAngle) / 180 * Math.PI) * _radius);
         y = Math.round($p.y - Math.sin((this._setupAngle * $i + this._initAngle) / 180 * Math.PI) * _radius);
         this.angle = this._setupAngle * $i + this._initAngle;
         this._bg = ComponentFactory.Instance.creat("gemstone.stoneContent");
         addChild(this._bg);
         this._bg.x = -this._bg.width / 2;
         this._bg.y = -this._bg.height / 2;
         this.txt = ComponentFactory.Instance.creatComponentByStylename("gemstoneTxt");
         this.txt.x = -61;
         this.txt.y = -21;
         tipStyle = "gemstone.items.GemstoneLeftViewTip";
         tipDirctions = "2,7";
      }
      
      public function loadSikn(str:String) : void
      {
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
            this._content = null;
         }
         this._content = ComponentFactory.Instance.creatBitmap(str);
         this._content.smoothing = true;
         this._content.x = -78;
         this._content.y = -79;
         this._content.scaleY = 0.8;
         this._content.scaleX = 0.8;
         addChild(this._content);
         addChild(this.txt);
      }
      
      public function upDataLevel() : void
      {
         this.txt.text = "LV" + this.info.level;
         this.updataTip();
      }
      
      public function updataTip() : void
      {
         var tempData:GemstoneTipVO = new GemstoneTipVO();
         tempData.level = this.info.level;
         var nextLevel:int = this.info.level < GemstoneManager.Instance.curMaxLevel ? this.info.level + 1 : 0;
         switch(this.info.fightSpiritId)
         {
            case 100001:
               tempData.gemstoneType = 1;
               tempData.increase = GemstoneManager.Instance.redInfoList[this.info.level].attack;
               tempData.nextIncrease = GemstoneManager.Instance.redInfoList[nextLevel].attack;
               break;
            case 100002:
               tempData.gemstoneType = 2;
               tempData.increase = GemstoneManager.Instance.bluInfoList[this.info.level].defence;
               tempData.nextIncrease = GemstoneManager.Instance.bluInfoList[nextLevel].defence;
               break;
            case 100003:
               tempData.gemstoneType = 3;
               tempData.increase = GemstoneManager.Instance.greInfoList[this.info.level].agility;
               tempData.nextIncrease = GemstoneManager.Instance.greInfoList[nextLevel].agility;
               break;
            case 100004:
               tempData.gemstoneType = 4;
               tempData.increase = GemstoneManager.Instance.yelInfoList[this.info.level].luck;
               tempData.nextIncrease = GemstoneManager.Instance.yelInfoList[nextLevel].luck;
               break;
            case 100005:
               tempData.gemstoneType = 5;
               tempData.increase = GemstoneManager.Instance.purpleInfoList[this.info.level].blood;
               tempData.nextIncrease = GemstoneManager.Instance.purpleInfoList[nextLevel].blood;
         }
         tipData = tempData;
      }
      
      public function selAlphe(i:Number) : void
      {
         this._content.alpha = i;
      }
      
      override public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

