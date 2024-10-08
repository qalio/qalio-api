package amazing

import "testing"

func TestInit(t *testing.T) {
	expected := "amazing module initialized"
	if got := Init(); got != expected {
		t.Errorf("Init() = %q, want %q", got, expected)
	}
}
