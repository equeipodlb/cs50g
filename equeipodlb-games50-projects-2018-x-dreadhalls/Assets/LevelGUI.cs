using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LevelGUI : MonoBehaviour
{

	public static int mazeCount = 0;
	private static Text levelUI;

    // Use this for initialization
    private void Start() {
        mazeCount++;
        levelUI = gameObject.GetComponent<Text>();
        levelUI.text = string.Concat("Level ", mazeCount.ToString());
    }

    public static void reset() {
        mazeCount = 0;
    }
}