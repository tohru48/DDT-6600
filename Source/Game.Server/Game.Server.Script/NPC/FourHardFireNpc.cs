// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FourHardFireNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FourHardFireNpc : ABrain
  {
    private int m_turn = 0;
    private int m_attackTurn = 0;
    private PhysicalObj m_moive = (PhysicalObj) null;

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
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
      {
        this.Die();
        this.m_attackTurn = 0;
      }
    }

    private void Move()
    {
      this.Body.MoveTo(this.Game.Random.Next(300, 980), this.Game.Random.Next(300, 600), "fly", 500, "", 6, new LivingCallBack(this.CreateChild));
    }

    public void Die()
    {
      this.Body.PlayMovie("cry", 1000, 0);
      this.Body.PlayMovie("die", 2000, 0);
      this.Body.Die(3000);
    }

    private void CreateChild()
    {
      this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.Body.X, this.Body.Y + 20, "moive", "game.living.Living141", "stand", 1, 0);
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
