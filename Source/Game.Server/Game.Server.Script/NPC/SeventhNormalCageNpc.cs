// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SeventhNormalCageNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class SeventhNormalCageNpc : ABrain
  {
    public override void OnStartAttacking()
    {
      if (this.Body.Blood != 0)
        return;
      this.Out();
    }

    private void Out() => this.Body.PlayMovie("out", 3000, 0);
  }
}
