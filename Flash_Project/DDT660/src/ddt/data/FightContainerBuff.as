package ddt.data
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.view.tips.BuffTipInfo;
   
   public class FightContainerBuff extends FightBuffInfo implements Disposeable
   {
      
      private var _buffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
      
      public function FightContainerBuff(id:int, $type:int = 2)
      {
         super(id);
         type = $type;
      }
      
      public function addFightBuff(buff:FightBuffInfo) : void
      {
         this._buffs.push(buff);
      }
      
      public function get tipData() : Object
      {
         var buffs:Vector.<BuffInfo> = null;
         var buff:BuffInfo = null;
         var fightBuff:FightBuffInfo = null;
         var data:BuffTipInfo = new BuffTipInfo();
         if(type == BuffType.Pay)
         {
            data.isActive = true;
            data.describe = LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Note");
            data.name = LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Name");
            data.isFree = false;
            buffs = new Vector.<BuffInfo>();
            for each(fightBuff in this._buffs)
            {
               if(BuffType.isPayBuff(fightBuff) && fightBuff.isSelf)
               {
                  buff = PlayerManager.Instance.Self.getBuff(fightBuff.id);
                  buff.calculatePayBuffValidDay();
               }
               else
               {
                  buff = new BuffInfo(fightBuff.id);
                  buff.day = fightBuff.data;
                  buff.isSelf = false;
               }
               buffs.push(buff);
            }
            data.linkBuffs = buffs;
         }
         else if(type == BuffType.CONSORTIA)
         {
            data.isActive = true;
            data.name = LanguageMgr.GetTranslation("tank.view.buff.consortiaBuff");
            data.isFree = false;
            data.linkBuffs = this._buffs;
         }
         else
         {
            data.isActive = true;
            data.name = LanguageMgr.GetTranslation("tank.view.buff.cardBuff");
            data.isFree = false;
            data.linkBuffs = this._buffs;
         }
         return data;
      }
      
      public function dispose() : void
      {
         this._buffs.length = 0;
      }
   }
}

