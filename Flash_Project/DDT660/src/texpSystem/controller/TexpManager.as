package texpSystem.controller
{
   import ddt.data.BuffInfo;
   import ddt.data.analyze.TexpExpAnalyze;
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import texpSystem.TexpEvent;
   import texpSystem.data.TexpExp;
   import texpSystem.data.TexpInfo;
   import texpSystem.data.TexpType;
   
   public class TexpManager extends EventDispatcher
   {
      
      private static var _instance:TexpManager;
      
      private static const MAX_LV:int = 75;
      
      private var _texpExp:Dictionary;
      
      public function TexpManager(enforcer:TexpManagerEnforcer)
      {
         super();
      }
      
      public static function get Instance() : TexpManager
      {
         if(!_instance)
         {
            _instance = new TexpManager(new TexpManagerEnforcer());
         }
         return _instance;
      }
      
      public function setup(analyzer:TexpExpAnalyze) : void
      {
         this._texpExp = analyzer.list;
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onChange);
      }
      
      public function getLv(exp:int) : int
      {
         var lv:int = 0;
         var t:TexpExp = null;
         for(var i:int = 1; i <= MAX_LV; i++)
         {
            t = this._texpExp[i];
            if(exp < t.GP)
            {
               break;
            }
            lv = i;
         }
         return lv;
      }
      
      public function getInfo(type:int, exp:int) : TexpInfo
      {
         var info:TexpInfo = new TexpInfo();
         var lv:int = this.getLv(exp);
         info.type = type;
         info.lv = lv;
         if(lv == 0)
         {
            info.currExp = exp;
            info.currEffect = 0;
            info.upExp = this._texpExp[1].GP;
            info.upEffect = this.getEffect(type,this._texpExp[lv + 1]);
         }
         else if(lv == MAX_LV)
         {
            info.currExp = 0;
            info.currEffect = this.getEffect(type,this._texpExp[lv]);
            info.upExp = 0;
            info.upEffect = 0;
         }
         else
         {
            info.currExp = exp - this._texpExp[lv].GP;
            info.currEffect = this.getEffect(type,this._texpExp[lv]);
            info.upExp = this._texpExp[lv + 1].GP - this._texpExp[lv].GP;
            info.upEffect = this.getEffect(type,this._texpExp[lv + 1]);
         }
         return info;
      }
      
      public function getName(type:int) : String
      {
         switch(type)
         {
            case TexpType.HP:
               return LanguageMgr.GetTranslation("texpSystem.view.TexpView.hp");
            case TexpType.ATT:
               return LanguageMgr.GetTranslation("texpSystem.view.TexpView.att");
            case TexpType.DEF:
               return LanguageMgr.GetTranslation("texpSystem.view.TexpView.def");
            case TexpType.SPD:
               return LanguageMgr.GetTranslation("texpSystem.view.TexpView.spd");
            case TexpType.LUK:
               return LanguageMgr.GetTranslation("texpSystem.view.TexpView.luk");
            default:
               return "";
         }
      }
      
      public function getExp(type:int) : int
      {
         var self:SelfInfo = PlayerManager.Instance.Self;
         switch(type)
         {
            case TexpType.HP:
               return self.hpTexpExp;
            case TexpType.ATT:
               return self.attTexpExp;
            case TexpType.DEF:
               return self.defTexpExp;
            case TexpType.SPD:
               return self.spdTexpExp;
            case TexpType.LUK:
               return self.lukTexpExp;
            default:
               return 0;
         }
      }
      
      public function isXiuLianDaShi(buffInfoData:DictionaryData) : Boolean
      {
         var buff:BuffInfo = null;
         var resultBool:Boolean = false;
         for each(buff in buffInfoData)
         {
            if(buff && buff.buffItemInfo && buff.buffItemInfo.TemplateID == 11911)
            {
               resultBool = true;
               break;
            }
         }
         return resultBool;
      }
      
      private function getEffect(type:int, exp:TexpExp) : int
      {
         switch(type)
         {
            case TexpType.HP:
               return exp.ExerciseH;
            case TexpType.ATT:
               return exp.ExerciseA;
            case TexpType.DEF:
               return exp.ExerciseD;
            case TexpType.SPD:
               return exp.ExerciseAG;
            case TexpType.LUK:
               return exp.ExerciseL;
            default:
               return 0;
         }
      }
      
      private function isUp(type:int, oldExp:int) : Boolean
      {
         var exp:int = this.getExp(type);
         if(this.getLv(exp) > this.getLv(oldExp))
         {
            return true;
         }
         return false;
      }
      
      private function __onChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["hpTexpExp"]))
         {
            dispatchEvent(new TexpEvent(TexpEvent.TEXP_HP));
            if(this.isUp(TexpType.HP,evt.lastValue["hpTexpExp"]))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpView.up",this.getName(TexpType.HP)));
            }
         }
         if(Boolean(evt.changedProperties["attTexpExp"]))
         {
            dispatchEvent(new TexpEvent(TexpEvent.TEXP_ATT));
            if(this.isUp(TexpType.ATT,evt.lastValue["attTexpExp"]))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpView.up",this.getName(TexpType.ATT)));
            }
         }
         if(Boolean(evt.changedProperties["defTexpExp"]))
         {
            dispatchEvent(new TexpEvent(TexpEvent.TEXP_DEF));
            if(this.isUp(TexpType.DEF,evt.lastValue["defTexpExp"]))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpView.up",this.getName(TexpType.DEF)));
            }
         }
         if(Boolean(evt.changedProperties["spdTexpExp"]))
         {
            dispatchEvent(new TexpEvent(TexpEvent.TEXP_SPD));
            if(this.isUp(TexpType.SPD,evt.lastValue["spdTexpExp"]))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpView.up",this.getName(TexpType.SPD)));
            }
         }
         if(Boolean(evt.changedProperties["lukTexpExp"]))
         {
            dispatchEvent(new TexpEvent(TexpEvent.TEXP_LUK));
            if(this.isUp(TexpType.LUK,evt.lastValue["lukTexpExp"]))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpView.up",this.getName(TexpType.LUK)));
            }
         }
      }
   }
}

class TexpManagerEnforcer
{
   
   public function TexpManagerEnforcer()
   {
      super();
   }
}
