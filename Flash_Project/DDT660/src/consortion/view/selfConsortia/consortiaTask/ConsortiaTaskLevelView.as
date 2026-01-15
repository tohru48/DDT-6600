package consortion.view.selfConsortia.consortiaTask
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.boss.ConsortiaBossLevelCell;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortiaTaskLevelView extends Sprite implements Disposeable
   {
      
      private var _txt:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _levelShowBtn:SimpleBitmapButton;
      
      private var _showSprite:Sprite;
      
      private var _selectedBg:Bitmap;
      
      private var _selectedCellList:Vector.<ConsortiaBossLevelCell>;
      
      private var _selectedSprite:Sprite;
      
      private var _selectedLevel:int;
      
      public function ConsortiaTaskLevelView()
      {
         super();
         this._selectedLevel = Math.ceil(PlayerManager.Instance.Self.consortiaInfo.Level / 2);
         this.initView();
         this.initEvent();
      }
      
      public function get selectedLevel() : int
      {
         return this._selectedLevel;
      }
      
      private function initView() : void
      {
         var tmp:ConsortiaBossLevelCell = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.conortion.taskLevelBg");
         this._levelShowBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.levelShowBtn");
         PositionUtils.setPos(this._levelShowBtn,"consortiaTask.levelShowBtnPos");
         this._txt = ComponentFactory.Instance.creatComponentByStylename("consortion.taskFrame.levelShowTxt");
         this._txt.text = LanguageMgr.GetTranslation("consortiaTaskFrame.levelSelected.levelTxt",this._selectedLevel);
         this._showSprite = new Sprite();
         this._showSprite.addChild(this._bg);
         this._showSprite.addChild(this._txt);
         this._showSprite.addChild(this._levelShowBtn);
         this._showSprite.buttonMode = true;
         this._showSprite.mouseChildren = false;
         addChild(this._showSprite);
         this._selectedBg = ComponentFactory.Instance.creatBitmap("asset.conortion.taskLevelSelectedBg");
         this._selectedSprite = new Sprite();
         PositionUtils.setPos(this._selectedSprite,"consortiaTask.levelSelectedSpritePos");
         this._selectedSprite.addChild(this._selectedBg);
         this._selectedCellList = new Vector.<ConsortiaBossLevelCell>();
         for(var i:int = 0; i < 5; i++)
         {
            tmp = new ConsortiaBossLevelCell(i + 1,"consortiaTaskFrame.levelSelected.levelTxt");
            tmp.x = 3;
            tmp.y = 3 + i * 28;
            tmp.changeLightSizePos(140,29,1,5);
            tmp.judgeMaxLevel(this._selectedLevel);
            tmp.addEventListener(MouseEvent.CLICK,this.selecteLevelHandler,false,0,true);
            this._selectedSprite.addChild(tmp);
         }
         addChild(this._selectedSprite);
         this._selectedSprite.visible = false;
      }
      
      private function initEvent() : void
      {
         this._showSprite.addEventListener(MouseEvent.CLICK,this.showOrHideSelectedSprite,false,0,true);
      }
      
      private function selecteLevelHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectedLevel = (event.target as ConsortiaBossLevelCell).level;
         this._txt.text = LanguageMgr.GetTranslation("consortiaTaskFrame.levelSelected.levelTxt",this._selectedLevel);
         this._selectedSprite.visible = false;
      }
      
      private function showOrHideSelectedSprite(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectedSprite.visible = !this._selectedSprite.visible;
      }
      
      public function dispose() : void
      {
         var tmp:ConsortiaBossLevelCell = null;
         this._showSprite.removeEventListener(MouseEvent.CLICK,this.showOrHideSelectedSprite);
         for each(tmp in this._selectedCellList)
         {
            tmp.removeEventListener(MouseEvent.CLICK,this.selecteLevelHandler);
         }
         ObjectUtils.disposeAllChildren(this._showSprite);
         ObjectUtils.disposeAllChildren(this._selectedSprite);
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._txt = null;
         this._bg = null;
         this._levelShowBtn = null;
         this._showSprite = null;
         this._selectedBg = null;
         this._selectedCellList = null;
         this._selectedSprite = null;
      }
   }
}

