package guardCore
{
	import com.pickgliss.ui.ComponentFactory;
	import ddt.CoreManager;
	import ddt.data.UIModuleTypes;
	import ddt.manager.PlayerManager;
	import ddt.utils.HelperUIModuleLoad;
	import flash.events.IEventDispatcher;
	import guardCore.analyzer.GuardCoreAnalyzer;
	import guardCore.analyzer.GuardCoreLevelAnayzer;
	import guardCore.data.GuardCoreInfo;
	import guardCore.data.GuardCoreLevelInfo;
	
	public class GuardCoreManager extends CoreManager
	{
		
		private static var _instance:GuardCoreManager;
		
		
		private var _list:Vector.<GuardCoreInfo>;
		
		private var _listLevel:Vector.<GuardCoreLevelInfo>;
		
		private var _minLevel:int;
		
		public function GuardCoreManager(param1:IEventDispatcher = null)
		{
			super(param1);
		}
		
		public static function get instance() : GuardCoreManager
		{
			if(!_instance)
			{
				_instance = new GuardCoreManager();
			}
			return _instance;
		}
		
		public function EnterStart() : void
		{
			//new HelperUIModuleLoad().loadUIModule([UIModuleTypes.GUARD_CORE],this.onComplete);
		}
		
		private function onComplete() : void
		{
			var _loc1_:* = ComponentFactory.Instance.creatComponentByStylename("guardCore.GuardCoreView");
			_loc1_.show();
		}
		
		public function analyzer(param1:GuardCoreAnalyzer) : void
		{
			this._list = param1.list;
			this.checkMinLevel();
		}
		
		public function analyzerLevel(param1:GuardCoreLevelAnayzer) : void
		{
			this._listLevel = param1.list;
		}
		
		public function getGuardCoreIsOpen(param1:int, param2:int) : Boolean
		{
			var _loc3_:int = this._list.length;
			var _loc4_:int = 0;
			while(_loc4_ < _loc3_)
			{
				if(this._list[_loc4_].Type == param2 && param1 >= this._list[_loc4_].GainGrade)
				{
					return true;
				}
				_loc4_++;
			}
			return false;
		}
		
		public function getGuardCoreInfo(param1:int, param2:int) : GuardCoreInfo
		{
			var _loc3_:GuardCoreInfo = null;
			var _loc4_:int = this._list.length;
			var _loc5_:int = 0;
			while(_loc5_ < _loc4_)
			{
				if(this._list[_loc5_].Type == param2 && param1 >= this._list[_loc5_].GuardGrade)
				{
					if(_loc3_ == null || _loc3_.SkillGrade < this._list[_loc5_].SkillGrade)
					{
						_loc3_ = this._list[_loc5_];
					}
				}
				_loc5_++;
			}
			return _loc3_;
		}
		
		public function getGuardCoreInfoBySkillGrade(param1:int, param2:int) : GuardCoreInfo
		{
			var _loc3_:int = this._list.length;
			var _loc4_:int = 0;
			while(_loc4_ < _loc3_)
			{
				if(this._list[_loc4_].Type == param2 && this._list[_loc4_].SkillGrade == param1)
				{
					return this._list[_loc4_];
				}
				_loc4_++;
			}
			return null;
		}
		
		public function getGuardCoreInfoByID(param1:int) : GuardCoreInfo
		{
			var _loc2_:int = this._list.length;
			var _loc3_:int = 0;
			while(_loc3_ < _loc2_)
			{
				if(this._list[_loc3_].ID == param1)
				{
					return this._list[_loc3_];
				}
				_loc3_++;
			}
			return null;
		}
		
		public function getGuardLevelInfo(param1:int) : GuardCoreLevelInfo
		{
			var _loc2_:int = this._listLevel.length;
			var _loc3_:int = 0;
			while(_loc3_ < _loc2_)
			{
				if(this._listLevel[_loc3_].Grade == param1)
				{
					return this._listLevel[_loc3_];
				}
				_loc3_++;
			}
			return null;
		}
		
		private function checkMinLevel() : void
		{
			var _loc1_:int = this._list.length;
			var _loc2_:int = 0;
			while(_loc2_ < _loc1_)
			{
				if(this._minLevel == 0 || this._list[_loc2_].GainGrade < this._minLevel)
				{
					this._minLevel = this._list[_loc2_].GainGrade;
				}
				_loc2_++;
			}
		}
		
		public function get guardCoreMinLevel() : int
		{
			return this._minLevel;
		}
		
		public function getSelfGuardCoreInfo() : GuardCoreInfo
		{
			return this.getGuardCoreInfoByID(PlayerManager.Instance.Self.guardCoreID);
		}
	}
}
