// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.QXBoss70099
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class QXBoss70099 : ABrain
  {
    public int currentCount = 0;
    public int Dander = 0;

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
