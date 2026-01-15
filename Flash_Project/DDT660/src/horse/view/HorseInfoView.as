package horse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import horse.HorseManager;
   import horse.data.HorseTemplateVo;
   
   public class HorseInfoView extends Sprite implements Disposeable
   {
      
      private var _level:int;
      
      private var _bg:Bitmap;
      
      private var _horseNameStrList:Array;
      
      private var _nameTxt:FilterFrameText;
      
      private var _horseMc:MovieClip;
      
      private var _levelStarTxtImage:Bitmap;
      
      private var _levelTxt:FilterFrameText;
      
      private var _starTxt:FilterFrameText;
      
      private var _starCellList:Vector.<HorseFrameLeftBottomStarCell>;
      
      private var _addPropertyValueTxtList:Vector.<FilterFrameText>;
      
      private var _curRidingBookHorseID:int;
      
      private var _bookHorseHeadBG:Bitmap;
      
      private var _bookHorseRidingState:FilterFrameText;
      
      private var _bookRidingHeadBitmap:Bitmap;
      
      public function HorseInfoView()
      {
         var j:int = 0;
         var tmp:HorseFrameLeftBottomStarCell = null;
         var nameTxt:FilterFrameText = null;
         var valueTxt:FilterFrameText = null;
         super();
         this.mouseEnabled = false;
         this._horseNameStrList = LanguageMgr.GetTranslation("horse.horseNameStr").split(",");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.horseInfoView.bg");
         addChild(this._bg);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.horseNameTxt");
         addChild(this._nameTxt);
         this._horseMc = ComponentFactory.Instance.creat("asset.horse.frame.horseMc");
         PositionUtils.setPos(this._horseMc,"horse.frame.horseMcPos");
         this._horseMc.mouseChildren = false;
         this._horseMc.mouseEnabled = false;
         this._horseMc.gotoAndStop(this._horseMc.totalFrames);
         addChild(this._horseMc);
         this._levelStarTxtImage = ComponentFactory.Instance.creatBitmap("asset.horse.frame.levelStarTxtImage");
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.levelStarTxt");
         this._starTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.levelStarTxt");
         PositionUtils.setPos(this._starTxt,"horse.frame.starTxtPos");
         this._levelStarTxtImage.y -= 26;
         this._levelTxt.y -= 26;
         this._starTxt.y -= 26;
         this._bookHorseHeadBG = ComponentFactory.Instance.creatBitmap("asset.horse.bookHeadBG");
         this._bookHorseHeadBG.x = 0;
         this._bookHorseHeadBG.y = 10;
         this._bookHorseRidingState = ComponentFactory.Instance.creat("horse.frame.BookRidingStateTxt");
         this._bookHorseRidingState.text = LanguageMgr.GetTranslation("horse.bookRidingAHorse");
         addChild(this._levelStarTxtImage);
         addChild(this._levelTxt);
         addChild(this._starTxt);
         addChild(this._bookHorseHeadBG);
         addChild(this._bookHorseRidingState);
         this._starCellList = new Vector.<HorseFrameLeftBottomStarCell>();
         for(var i:int = 0; i < 9; i++)
         {
            tmp = new HorseFrameLeftBottomStarCell();
            tmp.x = 76 + 35 * i;
            tmp.y = 345 - 26;
            addChild(tmp);
            this._starCellList.push(tmp);
         }
         this._addPropertyValueTxtList = new Vector.<FilterFrameText>();
         var nameStrList:Array = LanguageMgr.GetTranslation("horse.addPropertyNameStr").split(",");
         for(j = 0; j < 5; j++)
         {
            nameTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.addPorpertyNameTxt");
            nameTxt.text = nameStrList[j];
            nameTxt.x = 20 + 133 * (j % 3);
            nameTxt.y = 376 + 29 * int(j / 3);
            valueTxt = ComponentFactory.Instance.creatComponentByStylename("horse.frame.addPorpertyValueTxt");
            valueTxt.text = "0";
            valueTxt.x = 53 + 123 * (j % 3) + 51;
            valueTxt.y = 376 + 29 * int(j / 3);
            this._addPropertyValueTxtList.push(valueTxt);
            addChild(nameTxt);
            addChild(valueTxt);
         }
         this.refreshView();
      }
      
      private function refreshView() : void
      {
         var curHorse:int = int(this._level / 10) + 1;
         this._nameTxt.text = this._horseNameStrList[curHorse - 1];
         this._horseMc.gotoAndStop(curHorse);
         this._levelTxt.text = int(this._level / 10 + 1).toString();
         this._starTxt.text = String(this._level % 10);
         var startIndex:int = int(this._level / 10) * 10;
         for(var i:int = 0; i < 9; i++)
         {
            this._starCellList[i].refreshView(startIndex + i + 1,this._level);
         }
         var tmp:HorseTemplateVo = HorseManager.instance.getHorseTemplateInfoByLevel(this._level);
         if(Boolean(tmp))
         {
            this._addPropertyValueTxtList[0].text = tmp.AddDamage.toString();
            this._addPropertyValueTxtList[1].text = tmp.AddGuard.toString();
            this._addPropertyValueTxtList[2].text = tmp.AddBlood.toString();
            this._addPropertyValueTxtList[3].text = tmp.MagicAttack.toString();
            this._addPropertyValueTxtList[4].text = tmp.MagicDefence.toString();
         }
         if(this._bookRidingHeadBitmap != null && Boolean(this._bookRidingHeadBitmap.parent))
         {
            this._bookRidingHeadBitmap.parent.removeChild(this._bookRidingHeadBitmap);
            ObjectUtils.disposeObject(this._bookRidingHeadBitmap);
         }
         if(this._curRidingBookHorseID > 100)
         {
            this._bookHorseRidingState.text = LanguageMgr.GetTranslation("horse.bookRidingAHorse");
            this._bookHorseRidingState.filterString = "horse.bookriding.on.filter";
            this._bookHorseRidingState.textColor = 16771411;
            this._bookRidingHeadBitmap = ComponentFactory.Instance.creatBitmap("asset.horse.hd" + this._curRidingBookHorseID.toString());
         }
         else
         {
            this._bookHorseRidingState.text = LanguageMgr.GetTranslation("horse.bookRidingNone");
            this._bookHorseRidingState.filterString = "horse.bookriding.none.filter";
            this._bookHorseRidingState.textColor = 12829635;
            this._bookRidingHeadBitmap = ComponentFactory.Instance.creatBitmap("asset.horse.none");
         }
         addChild(this._bookRidingHeadBitmap);
      }
      
      public function set info(value:PlayerInfo) : void
      {
         this._level = value.curHorseLevel;
         this._curRidingBookHorseID = value.MountsType;
         this.refreshView();
      }
      
      public function dispose() : void
      {
      }
   }
}

