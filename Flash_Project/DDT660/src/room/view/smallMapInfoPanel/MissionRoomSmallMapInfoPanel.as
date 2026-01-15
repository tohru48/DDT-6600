package room.view.smallMapInfoPanel
{
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   
   public class MissionRoomSmallMapInfoPanel extends BaseSmallMapInfoPanel
   {
      
      protected var _modeTitle:FilterFrameText;
      
      protected var _mode:FilterFrameText;
      
      protected var _diffTitle:FilterFrameText;
      
      protected var _diff:FilterFrameText;
      
      protected var _levelRangeTitle:FilterFrameText;
      
      protected var _levelRange:FilterFrameText;
      
      protected var _titleLoader:DisplayLoader;
      
      public function MissionRoomSmallMapInfoPanel()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._diffTitle = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.diffTitle");
         addChild(this._diffTitle);
         this._modeTitle = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.modeTitle");
         addChild(this._modeTitle);
         this._levelRangeTitle = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.levelRangeTitle");
         addChild(this._levelRangeTitle);
         this._mode = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.mode");
         addChild(this._mode);
         this._diff = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.diff");
         addChild(this._diff);
         this._levelRange = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.levelRange");
         addChild(this._levelRange);
         this._diffTitle.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.diffTitle");
         this._modeTitle.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.mode");
         this._levelRangeTitle.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.levelRange");
         this._mode.text = LanguageMgr.GetTranslation("tank.view.effort.EffortCategoryTitleItem.DUNGEON");
      }
      
      override protected function updateView() : void
      {
         super.updateView();
         this._levelRangeTitle.visible = this._modeTitle.visible = this._diffTitle.visible = this._levelRange.visible = this._mode.visible = this._diff.visible = Boolean(_info) && _info.mapId != 0 && _info.mapId != 10000;
         this.solveLeveRange();
         this._diff.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.level" + _info.hardLevel);
      }
      
      private function solveLeveRange() : void
      {
         var array:Array = null;
         if(_info == null || _info.mapId == 0 || _info.mapId == 10000)
         {
            return;
         }
         var str:String = MapManager.getDungeonInfo(_info.mapId).AdviceTips;
         if(Boolean(str))
         {
            array = str.split("|");
            this._levelRange.text = "";
            if(_info.hardLevel >= array.length)
            {
               return;
            }
            this._levelRange.text = array[_info.hardLevel] + LanguageMgr.GetTranslation("grade");
         }
      }
      
      override public function dispose() : void
      {
         removeChild(this._modeTitle);
         if(Boolean(this._mode))
         {
            ObjectUtils.disposeObject(this._modeTitle);
            this._modeTitle = null;
         }
         if(Boolean(this._mode))
         {
            ObjectUtils.disposeObject(this._mode);
            this._mode = null;
         }
         if(Boolean(this._diffTitle))
         {
            ObjectUtils.disposeObject(this._diffTitle);
            this._diffTitle = null;
         }
         if(Boolean(this._diff))
         {
            ObjectUtils.disposeObject(this._diff);
            this._diff = null;
         }
         if(Boolean(this._levelRangeTitle))
         {
            ObjectUtils.disposeObject(this._levelRangeTitle);
            this._levelRangeTitle = null;
         }
         if(Boolean(this._levelRange))
         {
            ObjectUtils.disposeObject(this._levelRange);
            this._levelRange = null;
         }
         super.dispose();
      }
   }
}

