package horse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import horse.HorseManager;
   
   public class HorseFrameLeftBottomView extends Sprite implements Disposeable
   {
      
      private var _levelStarTxtImage:Bitmap;
      
      private var _levelTxt:FilterFrameText;
      
      private var _starTxt:FilterFrameText;
      
      private var _starCellList:Vector.<HorseFrameLeftBottomStarCell>;
      
      private var _progressTxtImage:Bitmap;
      
      private var _progressBg:Bitmap;
      
      private var _progressCover:Bitmap;
      
      private var _progressTxt:FilterFrameText;
      
      public function HorseFrameLeftBottomView()
      {
         super();
         this.initView();
         this.initEvent();
         this.refreshView();
      }
      
      private function initView() : void
      {
         var tmp:HorseFrameLeftBottomStarCell = null;
         this._levelStarTxtImage = ComponentFactory.Instance.creatBitmap("asset.horse.frame.levelStarTxtImage");
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.levelStarTxt");
         this._starTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.levelStarTxt");
         PositionUtils.setPos(this._starTxt,"horse.frame.starTxtPos");
         PositionUtils.setPos(this._levelTxt,"horse.frame.starTxtPos2");
         addChild(this._levelStarTxtImage);
         addChild(this._levelTxt);
         addChild(this._starTxt);
         this._starCellList = new Vector.<HorseFrameLeftBottomStarCell>();
         for(var i:int = 0; i < 9; i++)
         {
            tmp = new HorseFrameLeftBottomStarCell();
            tmp.x = 76 + 35 * i;
            tmp.y = 345;
            addChild(tmp);
            this._starCellList.push(tmp);
         }
         this._progressTxtImage = ComponentFactory.Instance.creatBitmap("asset.horse.frame.progressTxtImage");
         this._progressBg = ComponentFactory.Instance.creatBitmap("asset.horse.frame.progressBg");
         this._progressCover = ComponentFactory.Instance.creatBitmap("asset.horse.frame.progressCover");
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.progressTxt");
         this._progressTxt.text = "0/0";
         addChild(this._progressTxtImage);
         addChild(this._progressBg);
         addChild(this._progressCover);
         addChild(this._progressTxt);
      }
      
      private function initEvent() : void
      {
         HorseManager.instance.addEventListener(HorseManager.UP_HORSE_STEP_2,this.upHorseHandler);
      }
      
      private function upHorseHandler(event:Event) : void
      {
         this.refreshView();
      }
      
      private function refreshView() : void
      {
         var nextNeedTotalExp:int = 0;
         var curNeedTotalExp:int = 0;
         var curHasExp:int = 0;
         var nextNeedExp:int = 0;
         var curLevel:int = HorseManager.instance.curLevel;
         this._levelTxt.text = int(curLevel / 10 + 1).toString();
         this._starTxt.text = String(curLevel % 10);
         var startIndex:int = int(curLevel / 10) * 10;
         for(var i:int = 0; i < 9; i++)
         {
            this._starCellList[i].refreshView(startIndex + i + 1,curLevel);
         }
         if(curLevel >= 80)
         {
            this._progressTxt.text = "0/0";
            this._progressCover.scaleX = 1;
         }
         else
         {
            nextNeedTotalExp = HorseManager.instance.nextHorseTemplateInfo.Experience;
            curNeedTotalExp = HorseManager.instance.curHorseTemplateInfo.Experience;
            curHasExp = HorseManager.instance.curExp - curNeedTotalExp;
            nextNeedExp = nextNeedTotalExp - curNeedTotalExp;
            this._progressTxt.text = curHasExp + "/" + nextNeedExp;
            this._progressCover.scaleX = curHasExp / nextNeedExp;
         }
      }
      
      private function removeEvent() : void
      {
         HorseManager.instance.removeEventListener(HorseManager.UP_HORSE_STEP_2,this.upHorseHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._levelStarTxtImage = null;
         this._levelTxt = null;
         this._starTxt = null;
         this._starCellList = null;
         this._progressTxtImage = null;
         this._progressBg = null;
         this._progressCover = null;
         this._progressTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

