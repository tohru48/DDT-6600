package cardSystem.data
{
   import cardSystem.GrooveInfoManager;
   
   public class GrooveInfo
   {
      
      public var playerid:int;
      
      public var Place:int;
      
      public var Type:int;
      
      public var Level:int;
      
      public var GP:int;
      
      public var CardId:int;
      
      public function GrooveInfo()
      {
         super();
      }
      
      public function get realAttack() : int
      {
         var increate:int = 0;
         var i:int = 0;
         if(this.Level != 0)
         {
            increate = 0;
            for(i = 1; i <= this.Level; i++)
            {
               increate += int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Attack);
            }
            return increate;
         }
         return int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Attack);
      }
      
      public function get realDefence() : int
      {
         var increate:int = 0;
         var i:int = 0;
         if(this.Level != 0)
         {
            increate = 0;
            for(i = 1; i <= this.Level; i++)
            {
               increate += int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Defend);
            }
            return increate;
         }
         return int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Defend);
      }
      
      public function get realAgility() : int
      {
         var increate:int = 0;
         var i:int = 0;
         if(this.Level != 0)
         {
            increate = 0;
            for(i = 1; i <= this.Level; i++)
            {
               increate += int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Agility);
            }
            return increate;
         }
         return int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Agility);
      }
      
      public function get realLucky() : int
      {
         var increate:int = 0;
         var i:int = 0;
         if(this.Level != 0)
         {
            increate = 0;
            for(i = 1; i <= this.Level; i++)
            {
               increate += int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Lucky);
            }
            return increate;
         }
         return int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Lucky);
      }
      
      public function get realDamage() : int
      {
         var increate:int = 0;
         var i:int = 0;
         if(this.Level != 0)
         {
            increate = 0;
            for(i = 1; i <= this.Level; i++)
            {
               increate += int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Damage);
            }
            return increate;
         }
         return int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Damage);
      }
      
      public function get realGuard() : int
      {
         var increate:int = 0;
         var i:int = 0;
         if(this.Level != 0)
         {
            increate = 0;
            for(i = 1; i <= this.Level; i++)
            {
               increate += int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Guard);
            }
            return increate;
         }
         return int(GrooveInfoManager.instance.getInfoByLevel(String(i),String(this.Type)).Guard);
      }
   }
}

