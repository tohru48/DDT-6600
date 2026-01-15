// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Game.EvilTribeNormalGame
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;

#nullable disable
namespace GameServerScript.AI.Game
{
  public class EvilTribeNormalGame : APVEGameControl
  {
    public override void OnCreated()
    {
      this.Game.SetupMissions("3101,3102,3103,3104");
      this.Game.TotalMissionCount = 4;
    }

    public override void OnPrepated()
    {
    }

    public override int CalculateScoreGrade(int score)
    {
      if (score > 800)
        return 3;
      if (score > 725)
        return 2;
      return score > 650 ? 1 : 0;
    }

    public override void OnGameOverAllSession()
    {
    }
  }
}
