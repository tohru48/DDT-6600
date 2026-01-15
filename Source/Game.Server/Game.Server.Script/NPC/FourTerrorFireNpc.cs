// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FourTerrorFireNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FourTerrorFireNpc : ABrain
  {
    private int m_attackTurn = 0;
    private PhysicalObj m_moive = (PhysicalObj) null;

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      if (this.m_attackTurn == 0)
      {
        this.Move();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.Move();
        ++this.m_attackTurn;
      }
      else
        this.m_attackTurn = 0;
    }

    private void Move()
    {
      this.Body.MoveTo(this.Game.Random.Next(225, 1115), this.Game.Random.Next(113, 354), "fly", 500, "", 6, (LivingCallBack) null);
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.m_moive == null)
        return;
      this.Game.RemovePhysicalObj(this.m_moive, true);
      this.m_moive = (PhysicalObj) null;
    }
  }
}
