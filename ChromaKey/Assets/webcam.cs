using UnityEngine;
using System.Collections;
using UnityEngine.UI;

[ExecuteInEditMode]
public class webcam : MonoBehaviour {

	public bool execute;
	public AnimationCurve curve = AnimationCurve.Linear (0f, 0f, 1f, 1f);
	public Gradient RefrenceColor;
	public AnimationCurve saturationCurve = AnimationCurve.Linear (0f, 0f, 1f, 1f);
	public Gradient RefrenceSaturation;
	public AnimationCurve ValueCurve = AnimationCurve.Linear (0f, 0f, 1f, 1f);
	public Gradient ValueSaturation;
	public Texture2D texture;
	public float ligegyldig;

	// Use this for initialization
	void Start () {

		WebCamDevice[] devices = WebCamTexture.devices;

		if (devices.Length > 0) {

			WebCamTexture webcam = new WebCamTexture();

			webcam.deviceName = devices [0].name;
			gameObject.GetComponent<MeshRenderer> ().material.mainTexture = webcam;
			webcam.Play ();

		}
		else {
			print ("No webcam connected");
		}

	}

	// Update is called once per frame
	void Update () {

		//print (gameObject.GetComponent<MeshRenderer> ().material.name);

		if (execute == true) {

			execute = false;
			for (int i = 0; i < texture.width; i++) {

				Color color = new Color (ValueCurve.Evaluate((float)i/(float)texture.width),  curve.Evaluate((float)i/(float)texture.width), saturationCurve.Evaluate((float)i/(float)texture.width), 1);

				texture.SetPixel (i, 0, color);

				gameObject.GetComponent<MeshRenderer> ().material.SetTexture ("_AlphaTexture", texture);

				gameObject.GetComponent<MeshRenderer> ().material.SetFloat ("_Ligegyldig", ligegyldig);
			}

			texture.Apply();

		}
	}
}
