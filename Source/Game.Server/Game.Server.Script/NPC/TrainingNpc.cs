// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.TrainingNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class TrainingNpc : ABrain
  {
    private static int direction = 1;
    private int dis = 0;
    private int mtX = 0;

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      this.dis = this.Game.Random.Next(((SimpleNpc) this.Body).NpcInfo.MoveMin, ((SimpleNpc) this.Body).NpcInfo.MoveMax);
      if (TrainingNpc.direction == 1)
      {
        this.mtX = this.Body.X + this.dis;
        if (this.mtX > 800)
        {
          this.Body.MoveTo(800, this.Body.Y, "walk", 100, "", 3);
          TrainingNpc.direction = -TrainingNpc.direction;
        }
        else
          this.Body.MoveTo(this.mtX, this.Body.Y, "walk", 100, "", 3);
      }
      else
      {
        this.mtX = this.Body.X - this.dis;
        if (this.mtX < 100)
        {
          this.Body.MoveTo(100, this.Body.Y, "walk", 100, "", 3);
          TrainingNpc.direction = -TrainingNpc.direction;
        }
        else
          this.Body.MoveTo(this.mtX, this.Body.Y, "walk", 100, "", 3);
      }
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public void NextMove()
    {
      TrainingNpc.direction = -TrainingNpc.direction;
      if (TrainingNpc.direction == 1)
      {
        this.mtX = this.Body.X + this.dis;
        this.Body.MoveTo(this.mtX, this.Body.Y, "walk", 100, "", 3);
      }
      else
      {
        this.mtX = this.Body.X - this.dis;
        this.Body.MoveTo(this.mtX, this.Body.Y, "walk", 100, "", 3);
      }
    }
  }
}
