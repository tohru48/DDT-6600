package ddt.data
{
   import calendar.CalendarManager;
   import com.pickgliss.loader.ModuleLoader;
   import ddt.manager.LanguageMgr;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Living;
   
   public class FightBuffInfo
   {
      
      public static const DEFUALT_EFFECT:String = "asset.game.AttackEffect2";
      
      public var id:int;
      
      public var displayid:int = 0;
      
      public var type:int;
      
      private var _sigh:int = -1;
      
      public var buffPic:String = "";
      
      public var buffEffect:String = "";
      
      public var buffName:String = "FightBuffInfo";
      
      public var description:String = "unkown buff";
      
      public var priority:Number = 0;
      
      private var _data:int;
      
      private var _level:int;
      
      public var Count:int = 1;
      
      public var isSelf:Boolean;
      
      public function FightBuffInfo(id:int)
      {
         super();
         this.id = id;
         if(BuffType.isLuckyBuff(id))
         {
            this.buffName = LanguageMgr.GetTranslation("tank.game.BuffNameLucky",CalendarManager.getInstance().luckyNum >= 0 ? CalendarManager.getInstance().luckyNum : "");
         }
         else
         {
            this.buffName = LanguageMgr.GetTranslation("tank.game.BuffName" + this.id);
         }
      }
      
      public function get data() : int
      {
         return this._data;
      }
      
      public function set data(val:int) : void
      {
         var gameInfo:GameInfo = null;
         this._data = val;
         this.description = LanguageMgr.GetTranslation("tank.game.BuffTip" + this.id,this._data);
         if(this.id == 243 || this.id == 244 || this.id == 245 || this.id == 246)
         {
            gameInfo = GameManager.Instance.Current;
            if(gameInfo.mapIndex == 1214 || gameInfo.mapIndex == 1215 || gameInfo.mapIndex == 1216 || gameInfo.mapIndex == 1217)
            {
               this.description = LanguageMgr.GetTranslation("tank.game.BuffTip" + this.id + "1",this._data);
            }
         }
      }
      
      public function execute(living:Living) : void
      {
         if(this.type == BuffType.PET_BUFF)
         {
            if(Boolean(this.buffEffect))
            {
               if(ModuleLoader.hasDefinition("asset.game.skill.effect." + this.buffEffect))
               {
                  living.showBuffEffect("asset.game.skill.effect." + this.buffEffect,this.id);
               }
               else
               {
                  living.showBuffEffect(DEFUALT_EFFECT,this.id);
               }
            }
         }
         else
         {
            switch(this.id)
            {
               case BuffType.LockAngel:
                  living.isLockAngle = true;
            }
         }
      }
      
      public function unExecute(living:Living) : void
      {
         if(this.type == BuffType.PET_BUFF)
         {
            if(Boolean(this.buffEffect))
            {
               living.removeBuffEffect(this.id);
            }
         }
         else
         {
            switch(this.id)
            {
               case BuffType.LockAngel:
                  living.isLockAngle = false;
            }
         }
      }
   }
}

