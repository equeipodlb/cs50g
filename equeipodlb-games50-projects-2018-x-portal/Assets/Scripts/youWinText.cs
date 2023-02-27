using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class youWinText : MonoBehaviour
{
    private static Text text;
    // Start is called before the first frame update
    void Start() { 
        text = GetComponent<Text>();
        text.color = new Color(0, 0, 0, 0);
        text.text = "You win!";
    }

    // Update is called once per frame
    void Update() { }

    public static void show() {
        text.color = new Color(240,255,0,1);
    }
}
