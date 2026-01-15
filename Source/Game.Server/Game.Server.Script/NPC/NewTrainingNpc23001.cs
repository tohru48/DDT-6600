// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.NewTrainingNpc23001
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class NewTrainingNpc23001 : ABrain
  {
    private int dis = 0;

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      int[] numArray = new int[2]{ 1, -1 };
      this.dis = this.Game.Random.Next(30, 90);
      this.Body.MoveTo(this.Body.X + this.dis * numArray[this.Game.Random.Next(0, 2)], this.Body.Y, "walk", 3000, "", 3);
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();
  }
}
