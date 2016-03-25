using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class webcam : MonoBehaviour {
	
	public bool execute;
	public AnimationCurve curve = AnimationCurve.Linear (0f, 0f, 1f, 1f); 
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
				Color color = new Color (0, 0, 0, curve.Evaluate (i/texture.width));
				texture.SetPixel (i, 0, color);

				print (texture.GetPixel (i, 0).a);

				gameObject.GetComponent<MeshRenderer> ().material.SetTexture ("_AlphaTexture", texture);

				gameObject.GetComponent<MeshRenderer> ().material.SetFloat ("_Ligegyldig", ligegyldig);
			}
		} 
	}
}
