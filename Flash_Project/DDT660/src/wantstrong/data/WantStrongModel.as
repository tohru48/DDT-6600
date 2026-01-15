package wantstrong.data
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import wantstrong.WantStrongManager;
   
   public class WantStrongModel extends EventDispatcher implements Disposeable
   {
      
      private var _activeId:int = 1;
      
      private var _data:Dictionary;
      
      private var _titleArr:Array = ["ddt.wantStrong.view.texp","ddt.wantStrong.view.totem","ddt.wantStrong.view.gemstone","ddt.wantStrong.view.card","ddt.wantStrong.view.pet","ddt.wantStrong.view.equip","ddt.wantStrong.view.jewelery","ddt.wantStrong.view.gem","ddt.wantStrong.view.bead","ddt.wantStrong.view.bury","ddt.wantStrong.view.gold","ddt.wantStrong.view.power","ddt.wantStrong.view.fam","ddt.wantStrong.view.task","ddt.wantStrong.view.fight","ddt.wantStrong.view.daywright","ddt.wantStrong.view.treasure","ddt.wantStrong.view.dungeon"];
      
      private var _findBackTitleArr:Array = ["ddt.wantStrong.view.boss1","ddt.wantStrong.view.boss2","ddt.wantStrong.view.captain","ddt.wantStrong.view.battle","ddt.wantStrong.view.competition"];
      
      private var _descriptionArr:Array = ["ddt.wantStrong.view.texpDescription","ddt.wantStrong.view.totemDescription","ddt.wantStrong.view.gemstoneDescription","ddt.wantStrong.view.cardDescription","ddt.wantStrong.view.petDescription","ddt.wantStrong.view.equipDescription","ddt.wantStrong.view.jeweleryDescription","ddt.wantStrong.view.gemDescription","ddt.wantStrong.view.beadDescription","ddt.wantStrong.view.buryDescription","ddt.wantStrong.view.goldDescription","ddt.wantStrong.view.powerDescription","ddt.wantStrong.view.famDescription","ddt.wantStrong.view.taskDescription","ddt.wantStrong.view.fightDescription","ddt.wantStrong.view.daywrightDescription","ddt.wantStrong.view.treasureDescription","ddt.wantStrong.view.dungeonDescription"];
      
      private var _findBackDescriptionArr:Array = ["ddt.wantStrong.view.boss1Description","ddt.wantStrong.view.boss2Description","ddt.wantStrong.view.captainDescription","ddt.wantStrong.view.battleDescription","ddt.wantStrong.view.competitionDescription"];
      
      private var _starArr:Array = [5,5,5,4,5,5,4,5,5,5,5,4,5,5,4,5,4,5];
      
      private var _findBackStarArr:Array = [5,5,5,5,5];
      
      private var _iconArr:Array = ["wantstrong.texp","wantstrong.totem","wantstrong.gemstone","wantstrong.card","wantstrong.pet","wantstrong.equip","wantstrong.jewelery","wantstrong.gem","wantstrong.bead","wantstrong.bury","wantstrong.gold","wantstrong.power","wantstrong.fam","wantstrong.task","wantstrong.fight","wantstrong.daywright","wantstrong.treasure","wantstrong.dungeon"];
      
      private var _findBackIconArr:Array = ["wantstrong.boss1","wantstrong.boss2","wantstrong.captain","wantstrong.battle","wantstrong.competition"];
      
      private var _needLevelArr:Array = [13,20,30,14,25,8,8,8,16,26,20,30,30,8,8,8,10,18];
      
      private var _findBackNeedLevelArr:Array = [0,0,0,0,0];
      
      private var _idArr:Array = [101,102,103,104,105,106,107,108,109,110,111,112,201,202,203,301,302,401,501,502,503,504,505];
      
      private var _bossTypeDic:Dictionary;
      
      public function WantStrongModel(target:IEventDispatcher = null)
      {
         super(target);
         this._data = new Dictionary();
         this._bossTypeDic = new Dictionary();
         this._bossTypeDic[501] = 6;
         this._bossTypeDic[502] = 18;
         this._bossTypeDic[503] = 19;
         this._bossTypeDic[504] = 5;
         this._bossTypeDic[505] = 4;
      }
      
      public function get bossTypeDic() : Dictionary
      {
         return this._bossTypeDic;
      }
      
      public function initFindBackData() : void
      {
         var honorNum:int = 0;
         var worldBossMoneyNum:int = 0;
         var battleAwardNum:int = 0;
         var battleMoneyNum:int = 0;
         var leagureAwardNum:int = 0;
         var leagureMoneyNum:int = 0;
         var wantStrongData:WantStrongMenuData = null;
         var levelHonorArr:Array = null;
         var worldBossFindBackInfo:* = ServerConfigManager.instance.findInfoByName("WorldBossFindBack");
         var valueArr:Array = String(worldBossFindBackInfo.Value).split("|");
         for(var v_i:int = 0; v_i < valueArr.length; v_i++)
         {
            levelHonorArr = valueArr[v_i].split(",");
            if(PlayerManager.Instance.Self.Grade >= levelHonorArr[0] && PlayerManager.Instance.Self.Grade <= levelHonorArr[1])
            {
               honorNum = int(levelHonorArr[2]);
               break;
            }
         }
         var worldBossFindBackMoneyInfo:* = ServerConfigManager.instance.findInfoByName("WorldBossFindBackMoney");
         worldBossMoneyNum = worldBossFindBackMoneyInfo.Value * honorNum / 100;
         var FairBattleFindBackInfo:* = ServerConfigManager.instance.findInfoByName("FairBattleFindBackMoney");
         battleAwardNum = int(String(FairBattleFindBackInfo.Value).split(",")[1]);
         battleMoneyNum = int(String(FairBattleFindBackInfo.Value).split(",")[0]);
         var leagureFindBackInfo:* = ServerConfigManager.instance.findInfoByName("DailyLeagueFindBackMoney");
         leagureAwardNum = int(String(leagureFindBackInfo.Value).split(",")[1]);
         leagureMoneyNum = int(String(leagureFindBackInfo.Value).split(",")[0]);
         var data:Vector.<WantStrongMenuData> = new Vector.<WantStrongMenuData>();
         for(var i:int = 0; i < WantStrongManager.Instance.findBackDataExist.length; i++)
         {
            if(Boolean(WantStrongManager.Instance.findBackDataExist[i]))
            {
               wantStrongData = new WantStrongMenuData();
               wantStrongData.title = LanguageMgr.GetTranslation(this._findBackTitleArr[i]);
               wantStrongData.starNum = this._findBackStarArr[i];
               wantStrongData.description = LanguageMgr.GetTranslation(this._findBackDescriptionArr[i]);
               wantStrongData.needLevel = this._findBackNeedLevelArr[i];
               wantStrongData.iconUrl = this._findBackIconArr[i];
               wantStrongData.id = this._idArr[i + 18];
               wantStrongData.type = 5;
               wantStrongData.bossType = this._bossTypeDic[wantStrongData.id];
               wantStrongData.freeBackBtnEnable = WantStrongManager.Instance.findBackDic[wantStrongData.bossType] == null ? true : !WantStrongManager.Instance.findBackDic[wantStrongData.bossType][0];
               wantStrongData.allBackBtnEnable = WantStrongManager.Instance.findBackDic[wantStrongData.bossType] == null ? true : !WantStrongManager.Instance.findBackDic[wantStrongData.bossType][1];
               if(i < this._findBackTitleArr.length - 2)
               {
                  wantStrongData.awardType = 1;
                  wantStrongData.awardNum = honorNum;
                  wantStrongData.moneyNum = worldBossMoneyNum;
               }
               else if(i == this._findBackTitleArr.length - 2)
               {
                  wantStrongData.awardType = 2;
                  wantStrongData.awardNum = battleAwardNum;
                  wantStrongData.moneyNum = battleMoneyNum;
               }
               else if(i == this._findBackTitleArr.length - 1)
               {
                  wantStrongData.awardType = 3;
                  wantStrongData.awardNum = leagureAwardNum;
                  wantStrongData.moneyNum = leagureMoneyNum;
               }
               if(wantStrongData.bossType != 18)
               {
                  data.push(wantStrongData);
               }
            }
         }
         this._data[5] = data;
      }
      
      public function initData() : void
      {
         var data:Vector.<WantStrongMenuData> = null;
         var wantStrongData:WantStrongMenuData = null;
         var i1:int = 0;
         var i2:int = 0;
         var i3:int = 0;
         for(var vFlag:int = 0; vFlag < 4; vFlag++)
         {
            data = new Vector.<WantStrongMenuData>();
            if(vFlag == 0)
            {
               for(i1 = 0; i1 < 12; i1++)
               {
                  if(this._needLevelArr[i1] <= PlayerManager.Instance.Self.Grade)
                  {
                     wantStrongData = new WantStrongMenuData();
                     wantStrongData.title = LanguageMgr.GetTranslation(this._titleArr[i1]);
                     wantStrongData.starNum = this._starArr[i1];
                     wantStrongData.description = LanguageMgr.GetTranslation(this._descriptionArr[i1]);
                     wantStrongData.needLevel = this._needLevelArr[i1];
                     wantStrongData.iconUrl = this._iconArr[i1];
                     wantStrongData.id = this._idArr[i1];
                     wantStrongData.type = 1;
                     data.push(wantStrongData);
                  }
               }
               if(data.length > 0)
               {
                  this._data[1] = data;
               }
            }
            else if(vFlag == 1)
            {
               for(i2 = 12; i2 < 15; i2++)
               {
                  if(this._needLevelArr[i2] <= PlayerManager.Instance.Self.Grade)
                  {
                     wantStrongData = new WantStrongMenuData();
                     wantStrongData.title = LanguageMgr.GetTranslation(this._titleArr[i2]);
                     wantStrongData.starNum = this._starArr[i2];
                     wantStrongData.description = LanguageMgr.GetTranslation(this._descriptionArr[i2]);
                     wantStrongData.needLevel = this._needLevelArr[i2];
                     wantStrongData.iconUrl = this._iconArr[i2];
                     wantStrongData.id = this._idArr[i2];
                     wantStrongData.type = 2;
                     data.push(wantStrongData);
                  }
               }
               if(data.length > 0)
               {
                  this._data[2] = data;
               }
            }
            else if(vFlag == 2)
            {
               for(i3 = 15; i3 < 17; i3++)
               {
                  if(this._needLevelArr[i3] <= PlayerManager.Instance.Self.Grade)
                  {
                     wantStrongData = new WantStrongMenuData();
                     wantStrongData.title = LanguageMgr.GetTranslation(this._titleArr[i3]);
                     wantStrongData.starNum = this._starArr[i3];
                     wantStrongData.description = LanguageMgr.GetTranslation(this._descriptionArr[i3]);
                     wantStrongData.needLevel = this._needLevelArr[i3];
                     wantStrongData.iconUrl = this._iconArr[i3];
                     wantStrongData.id = this._idArr[i3];
                     wantStrongData.type = 3;
                     data.push(wantStrongData);
                  }
               }
               if(data.length > 0)
               {
                  this._data[3] = data;
               }
            }
            else if(vFlag == 3)
            {
               if(this._needLevelArr[17] <= PlayerManager.Instance.Self.Grade)
               {
                  wantStrongData = new WantStrongMenuData();
                  wantStrongData.title = LanguageMgr.GetTranslation(this._titleArr[17]);
                  wantStrongData.starNum = this._starArr[17];
                  wantStrongData.description = LanguageMgr.GetTranslation(this._descriptionArr[17]);
                  wantStrongData.needLevel = this._needLevelArr[17];
                  wantStrongData.iconUrl = this._iconArr[17];
                  wantStrongData.id = this._idArr[17];
                  wantStrongData.type = 4;
                  data.push(wantStrongData);
                  if(data.length > 0)
                  {
                     this._data[4] = data;
                  }
               }
            }
         }
      }
      
      public function get data() : Dictionary
      {
         return this._data;
      }
      
      public function get activeId() : int
      {
         return this._activeId;
      }
      
      public function set activeId(value:int) : void
      {
         this._activeId = value;
      }
      
      public function dispose() : void
      {
      }
   }
}

