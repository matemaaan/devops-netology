echo '-- get pods'
kubectl get pods
echo '-- check from frontend to frontend'
kubectl exec frontend-7ddf66cbb-rn7qs -- curl -m 10 frontend
echo '-- check from frontend to backend'
kubectl exec frontend-7ddf66cbb-rn7qs -- curl -m 10 backend
echo '-- check from frontend to cache'
kubectl exec frontend-7ddf66cbb-rn7qs -- curl -m 10 cache
echo '-- check from backend to frontend'
kubectl exec backend-5c496f8f74-b2r5l -- curl -m 10 frontend
echo '-- check from backend to backend'
kubectl exec backend-5c496f8f74-b2r5l -- curl -m 10 backend
echo '-- check from backend to cache'
kubectl exec backend-5c496f8f74-b2r5l -- curl -m 10 cache
echo '-- check from cache to frontend'
kubectl exec cache-5cd6c7468-8q9s9 -- curl -m 10 frontend
echo '-- check from cache to backend'
kubectl exec cache-5cd6c7468-8q9s9 -- curl -m 10 backend
echo '-- check from cache to cache'
kubectl exec cache-5cd6c7468-8q9s9 -- curl -m 10 cache
